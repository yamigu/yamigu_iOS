//
//  MatchCell.swift
//  yamigu
//
//  Created by Yoon on 21/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import Cosmos

class MatchCell: UICollectionViewCell {
    
    @IBOutlet weak var view_textContainer: UIView!
    @IBOutlet var textUnderline: [UIView]!
    
    @IBOutlet weak var label_meetingType: UILabel!
    @IBOutlet weak var image_profile: UIImageView!
   
    @IBOutlet weak var textview_details: UITextView!
    
    @IBOutlet weak var image_bottom: UIImageView!
    
    @IBOutlet weak var label_nicknameAndAge: UILabel!
    @IBOutlet weak var label_belongAndDepartment: UILabel!
    
    @IBOutlet weak var label_meetingDate: UILabel!
    @IBOutlet weak var label_meetingPlace: UILabel!
    
    @IBOutlet weak var bottomContainerView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image_profile.image = UIImage(named: "sample_profile")
    }
    
    override func prepareForReuse() {
        image_profile.image = UIImage(named: "sample_profile")
    }

}
