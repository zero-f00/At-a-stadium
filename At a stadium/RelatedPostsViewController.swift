//
//  RelatedPostsViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/06/12.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

//import UIKit
//import Firebase
//
//class RelatedPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    // 投稿データを格納する配列
//    var relatedPostArray: [PostData] = []
//    
//    // 試合情報データを格納する配列
//    var relatedMatchInfoArray: [MatchData] = []
//    
//    var listener: ListenerRegistration!
//    
//    var matchInfolistener: ListenerRegistration!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.rowHeight = 500
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        // カスタムセルを登録する
//        let nib = UINib(nibName: "RelatedPostsTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "RelatedPostsCell")
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("DEBUG_PRINT: viewWillAppear")
//        
//        if Auth.auth().currentUser != nil {
//            // ログイン済み
//            if listener == nil || matchInfolistener == nil {
//                // listener未登録なら、登録してスナップショットを受信する
//                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
//                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
//                    if let error = error {
//                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
//                        return
//                    }
//                    // 最新の情報を取得するための処理
//                    // 取得したdocumentをもとにPostDataを作成し、relatedPostArrayの配列にする。
//                    self.relatedPostArray = querySnapshot!.documents.map { document in
//                        print("DEBUG_PRINT: document取得 \(document.documentID)")
//                        let postData = PostData(document: document)
//                        return postData
//                    }
//                    // TableViewの表示を更新する
//                    self.tableView.reloadData()
//                }
//                
//                
//                // listener未登録なら、登録してスナップショットを受信する
//                let matchInfoPostRef = Firestore.firestore().collection(Const.MatchCreatePath).order(by: "date", descending: true)
//                matchInfolistener = matchInfoPostRef.addSnapshotListener() { (querySnapshot, error) in
//                    if let error = error {
//                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
//                        return
//                    }
//                    // 取得したdocumentをもとにSelectedMatchInfoDataを作成し、SelectedMatchInfoDataArrayの配列にする。
//                    self.relatedMatchInfoArray = querySnapshot!.documents.map { document in
//                        print("DEBUG_PRINT: document取得 \(document.documentID)")
//                        let matchData = MatchData(document: document)
//
//                        print("--------------------------")
//                        print(matchData.id)
//                        print("カテゴリセクション\(String(describing: matchData.category))")
//                        print("セクション\(String(describing: matchData.section))")
//                        print("ホーム\(String(describing: matchData.homeTeam))")
//                        print("アウェイ\(String(describing: matchData.awayTeam))")
//                        print("デート\(String(describing: matchData.date))")
//
//                        return matchData
//                    }
//                    // TableViewの表示を更新する
//                    self.tableView.reloadData()
//                }
//            }
//        } else {
//            if listener != nil {
//                // listener登録済みなら削除してpostArrayをクリアする
//                listener.remove()
//                listener = nil
//                relatedPostArray = []
//                
//                // listener登録済みなら削除してSelectedMatchInfoDataArrayをクリアする
//                matchInfolistener.remove()
//                matchInfolistener = nil
//                relatedMatchInfoArray = []
//                
//                tableView.reloadData()
//            }
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return relatedPostArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // セルを取得してデータを設定する
//         let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedPostsCell", for: indexPath) as! RelatedPostsTableViewCell
//        cell.setPostData(relatedPostArray[indexPath.row])
//        
//        for postData in relatedPostArray {
//            if postData.id == sortMatchInfo!.id {
//                cell.setPostData(postData)
//            }
//        }
//        
//        return cell
//    }
//}
