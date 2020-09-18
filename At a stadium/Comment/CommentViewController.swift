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
        
        let nib = UINib(nibName: "CommentVCPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentVCPostCell")
        
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "CommentCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
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
                    // 最新の情報を取得するための処理
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    self.commentPostArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            // ログアウト未（またはログアウト済み）
            if listener != nil {
                // listener登録済みなら削除してmatchInfoArrayをクリアする
                listener.remove()
                listener = nil
                commentPostArray = []
                tableView.reloadData()
            }
        }
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
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            cell2.setCommentPostData(commentPostArray[indexPath.row])
            
            return cell2
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
