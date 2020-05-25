//
//  PostViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/04.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import YPImagePicker
import Firebase
import SVProgressHUD


class PostViewController: UIViewController {
    
    var image: UIImage!
    
    var config = YPImagePickerConfiguration()
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キャプションを入力するテキストエリアをからの状態にしておく
        caption.text = ""
        // viewが立ち上がった直後にキーボードが立ち上がるようにする
        caption.becomeFirstResponder()
        
        // YPImagePickerのタブの名前
        config.wordings.libraryTitle = "ライブラリ"
        config.wordings.cameraTitle = "写真"
        config.wordings.next = "OK"
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        caption.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButton_Clicked(_ sender: Any) {
        
        if self.image == nil {
            SVProgressHUD.showError(withStatus:"画像の投稿は必須です。")
            postButton.isEnabled = false
            mastTapImage()
        } else {
            // キーボードを閉じる
            caption.resignFirstResponder()
            
            // 画像をJPEG形式に変換する
            let imageData = image.jpegData(compressionQuality: 0.75)
            // 画像と投稿データの保存場所を定義
            let postRef = Firestore.firestore().collection(Const.PostPath).document()
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
            
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show()
            
            // Storageに画像をアップロードする
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    // 画像のアップロードに失敗
                    print(error!)
                    SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました。")
                    
                    // 投稿処理をキャンセル
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    return
                }
                
                // FireStoreに投稿データを保存する
                let name = Auth.auth().currentUser?.displayName
                let postDic = [
                    "name": name!,
                    "caption": self.caption.text!,
                    "date": FieldValue.serverTimestamp(),
                ] as [String : Any]
                postRef.setData(postDic)
                
                // HUDで投稿完了を表示
                SVProgressHUD.showSuccess(withStatus: "投稿完了")
                
                // 投稿処理が完了したので先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func tapImage(_ sender: Any) {
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                // 受け取った画像をImageViewに設定する
                self.postImage.image = photo.originalImage
                self.image = photo.originalImage
                self.postButton.isEnabled = true
            }
            picker.dismiss(animated: true, completion: nil)

        }
        present(picker, animated: true, completion: nil)
    }
    
    func mastTapImage() {
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                // 受け取った画像をImageViewに設定する
                self.postImage.image = photo.originalImage
                self.image = photo.originalImage
                // ポストボタンを押せるようにする
                self.postButton.isEnabled = true
            }
            picker.dismiss(animated: true, completion: nil)

        }
        present(picker, animated: true, completion: nil)
    }
    
}
