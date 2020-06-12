//
//  SelectedMatchInfoData.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/06/07.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import Foundation
import Firebase

class SelectedMatchInfoData: NSObject {
    var id: String
    var categorySection: String?
    var matchDate: String?
    var homeTeam: String?
    var awayTeam: String?
    var date: Date?
    
    init(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.categorySection = postDic["categorySection"] as? String
        
        self.matchDate = postDic["matchDate"] as? String
        
        self.homeTeam = postDic["homeTeam"] as? String
        
        self.awayTeam = postDic["awayTeam"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
    }
}
