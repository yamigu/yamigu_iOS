//
//  HomeMyTableViewCell.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class HomeMyTableViewCell: UITableViewCell {

    @IBOutlet weak var label_chattingCount: UILabel!
    @IBOutlet weak var label_chattingTime: UILabel!
    @IBOutlet weak var label_lastChat: UILabel!
    @IBOutlet weak var label_dday: UILabel!
    @IBOutlet weak var label_day: UILabel!
    @IBOutlet weak var label_month: UILabel!
    @IBOutlet weak var label_type: UILabel!
    @IBOutlet weak var label_place: UILabel!
    @IBOutlet weak var label_teamCount: UILabel!
    @IBOutlet weak var button_applyTeam: UIButton!
    @IBOutlet weak var button_watingTeam: UIButton!
    @IBOutlet weak var button_edit: UIButton!
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
