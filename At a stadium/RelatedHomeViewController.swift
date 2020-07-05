//
//  RelatedHomeViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/06/17.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class RelatedHomeViewController: UIViewController {
    
    @IBOutlet weak var relatedCategorySectionLabel: UILabel!
    @IBOutlet weak var relatedHomeTeamLabel: UILabel!
    @IBOutlet weak var relatedAwayTeamLabel: UILabel!
    @IBOutlet weak var relatedStadiumLabel: UILabel!
    @IBOutlet weak var relatedStadiumImageView: UIImageView!
    @IBOutlet weak var relatedDateLabel: UILabel!
    
    
    var matchInfoFromHomeVC: MatchData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let relatedHomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "RelatedHomeVC") as! RelatedHomeViewController
        
        let relatedPostsViewController = relatedHomeViewController.children[0] as! RelatedPostsViewController
        relatedPostsViewController.sortMatchInfo = matchInfoFromHomeVC
        
        // カテゴリとセクションの表示
        self.relatedCategorySectionLabel.text = "\(matchInfoFromHomeVC!.category!) \(matchInfoFromHomeVC!.section!)"
        
        // ホームチームの表示
        self.relatedHomeTeamLabel.text = matchInfoFromHomeVC!.homeTeam!
        
        // アウェイチームの表示
        self.relatedAwayTeamLabel.text = matchInfoFromHomeVC!.awayTeam!
        
        // KICKOFFの表示
        self.relatedDateLabel.text = ""
        if let date = matchInfoFromHomeVC!.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
            self.relatedDateLabel.text = "KICKOFF - \(dateAndTime)"
        }
        
        // スタジアム画像の表示
        relatedStadiumImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(matchInfoFromHomeVC!.id + ".jpg")
        relatedStadiumImageView.sd_setImage(with: imageRef)
    }

}
