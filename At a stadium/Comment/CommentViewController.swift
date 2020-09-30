//
//  CommentViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/08/24.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TextField: UITextField!
    
    // HomeVCで選択された投稿データ
    var postData: PostData!
    
    // 投稿データを格納する配列
    var commentPostArray: [PostData] = []
    
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録する
        // 投稿データ用のnib
        let nib = UINib(nibName: "CommentVCPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentVCPostCell")
        
        // コメント表示用のnib
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "CommentCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    
                    self.commentPostArray = querySnapshot!.documents
                        .map { PostData(document: $0) }
                        .filter { $0.id == self.postData!.id
                        }
                    
                    
                    
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                commentPostArray = []
                
                tableView.reloadData()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentPostArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentVCPostCell", for: indexPath) as! CommentVCPostTableViewCell
            cell.setCommentVCPostData(postData)
            return cell
        } else {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            cell.setCommentPostData(commentPostArray[indexPath.row - 1])
            
            return cell
        }
    }
    
    @IBAction func handleCommentPostButton(_ sender: Any) {
        let commentTextField = TextField.text!
        
        // commentsを更新する
        if let myid = Auth.auth().currentUser?.displayName {
            
            if commentTextField.isEmpty {
                SVProgressHUD.showError(withStatus:"コメントを入力してください。")
            } else {
                
                // 更新データを作成する
                var updateValueComment: FieldValue
                updateValueComment = FieldValue.arrayUnion([myid + commentTextField])
                
                // commentsTextに更新データを書き込む
                let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                postRef.updateData(["commentsText": updateValueComment])
                
                SVProgressHUD.showSuccess(withStatus: "投稿しました。")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
