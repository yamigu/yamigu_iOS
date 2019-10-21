//
//  WatingTableViewCell.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import Cosmos

class WatingTableViewCell: UITableViewCell {

    @IBOutlet weak var label_type: UILabel!
    @IBOutlet weak var label_nickname: UILabel!
    @IBOutlet weak var label_belong: UILabel!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_place: UILabel!
    @IBOutlet weak var tv_description: UITextView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var image_profile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
