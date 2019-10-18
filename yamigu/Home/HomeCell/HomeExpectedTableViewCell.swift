//
//  HomeExpectedTableViewCell.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class HomeExpectedTableViewCell: UITableViewCell {

    @IBOutlet weak var label_type: UILabel!
    @IBOutlet weak var label_place: UILabel!
    @IBOutlet weak var label_belong_age_1: UILabel!
    @IBOutlet weak var label_belong_age_2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
