//
//  MyPageViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/03.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase

class MyPageViewController: UIViewController {
    
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG_PRINT: viewWillAppear")
        
//        // currentUserがnilならログインしていない
//        if Auth.auth().currentUser == nil {
//            // ログインしていないときの処理
//            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
//            self.present(loginViewController!, animated: true)
//        } else {
//            if listener == nil {
//                // listener未登録なら、登録してスナップショットを受信する
//            }
//        }
    }
    
    @IBAction func toEditAccount(_ sender: Any) {
        
    }
    
    
    

}
