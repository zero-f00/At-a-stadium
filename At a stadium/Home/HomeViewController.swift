//
//  HomeViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/03.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 変数データを格納する配列（投稿内容用）
    var postArray: [PostData] = []
    
    // 変数データを格納する配列（試合情報用）
    var selectedMatchInfoDataArray: [SelectedMatchInfoData] = []
    
    // RelatedHomeViewControllerに試合情報を表示させるための変数
    var matchInfoToRelated: SelectedMatchInfoData?
    
    var listener: ListenerRegistration!
    
    var matchInfolistener: ListenerRegistration!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = 900
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
        override func viewWillAppear(_ animated:Bool) {
            super.viewWillAppear(animated)
            print("DEBUG_PRINT: viewWillAppear")
            
            if Auth.auth().currentUser != nil {
                // ログイン済み
                if listener == nil || matchInfolistener == nil {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                    listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                    }
                    
                    
                    // listener未登録なら、登録してスナップショットを受信する
                    let matchInfoPostRef = Firestore.firestore().collection(Const.MatchInfoPostPath).order(by: "date", descending: true)
                    matchInfolistener = matchInfoPostRef.addSnapshotListener() { (querySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにSelectedMatchInfoDataを作成し、SelectedMatchInfoDataArrayの配列にする。
                        self.selectedMatchInfoDataArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let selectedMatchInfoData = SelectedMatchInfoData(document: document)
                            
                            print("--------------------------")
                            print(selectedMatchInfoData.id)
                            print("カテゴリセクション\(String(describing: selectedMatchInfoData.categorySection))")
                            print("ホーム\(String(describing: selectedMatchInfoData.homeTeam))")
                            print("アウェイ\(String(describing: selectedMatchInfoData.awayTeam))")
                            print("デート\(String(describing: selectedMatchInfoData.matchDate))")
                            
                            return selectedMatchInfoData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                    }
                }
            } else {
                if listener != nil || matchInfolistener != nil {
                    // listener登録済みなら削除してpostArrayをクリアする
                    listener.remove()
                    listener = nil
                    postArray = []
                    
                    // listener登録済みなら削除してSelectedMatchInfoDataArrayをクリアする
                    matchInfolistener.remove()
                    matchInfolistener = nil
                    selectedMatchInfoDataArray = []
                    
                    tableView.reloadData()
                }
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        if indexPath.row < selectedMatchInfoDataArray.count {
            cell.setSelectedMatchInfoData(selectedMatchInfoDataArray[indexPath.row])
        }
        cell.addMatchInfoButton.addTarget(self, action: #selector(didTapAddMatchInfo), for: .touchUpInside)
        return cell
    }
    
    @objc func didTapAddMatchInfo(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        matchInfoToRelated = selectedMatchInfoDataArray[indexPath!.row]
        
        // viewがタップされた時のアクション
        self.performSegue(withIdentifier: "toRelatedPosts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let relatedHomeViewController = segue.destination as! RelatedHomeViewController
        relatedHomeViewController.matchInfoFromHomeVC = matchInfoToRelated
        
        print("DEBUG_PRINT matchInfoFromHomeVCに値を渡す \(String(describing: matchInfoToRelated))")
        
        self.dismiss(animated: true, completion: nil)
    }

}
