//
//  HomeCollectionViewCell.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label_meetingType: UILabel!
     @IBOutlet weak var image_profile: UIImageView!
    
     @IBOutlet weak var textview_details: UITextView!
     
     @IBOutlet weak var image_bottom: UIImageView!
     
     @IBOutlet weak var label_nicknameAndAge: UILabel!
     @IBOutlet weak var label_belongAndDepartment: UILabel!
     
     @IBOutlet weak var label_meetingDate: UILabel!
     @IBOutlet weak var label_meetingPlace: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.image_profile.image = UIImage(named: "sample_profile")
    }
    override func prepareForReuse() {
        self.image_profile.image = UIImage(named: "sample_profile")
    }

}
