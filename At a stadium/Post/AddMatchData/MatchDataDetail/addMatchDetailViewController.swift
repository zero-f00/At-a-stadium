//
//  addMatchDetailViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/24.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit

class addMatchDetailViewController: UIViewController {
    
    @IBOutlet weak var categorySectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var stadiumImageView: UIImageView!
    
    
    var matchInfoDetail: MatchData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // カテゴリの表示 セクションの表示
//        self.categorySectionLabel.text = "\(matchInfoDetail.category!) \(matchInfoDetail.section!)"
//        print("DEBUG_PRINT \(String(describing: self.categorySectionLabel.text))")
        
    }
    
}
