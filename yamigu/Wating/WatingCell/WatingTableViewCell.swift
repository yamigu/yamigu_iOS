//
//  WatingTableViewCell.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import Cosmos

protocol WatingTableViewDelegate : class {
    func meetingBtnPressed()
}

class WatingTableViewCell: UITableViewCell {
    
    weak var delegate : WatingTableViewDelegate!

    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var image_bottomBar: UIImageView!
    @IBOutlet weak var button_meeting: UIButton!
    @IBOutlet weak var label_type: UILabel!
    @IBOutlet weak var label_nickname: UILabel!
    @IBOutlet weak var label_belong: UILabel!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_place: UILabel!
    @IBOutlet weak var textview_detail: UITextView!
    
    @IBOutlet weak var image_profile: UIImageView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.button_meeting.isHidden = true
        self.constraintHeight.constant = 0.0
        self.layoutIfNeeded()
        
    }
    
    @IBAction func meetingBtnPressed(_ sender: Any) {
        self.delegate.meetingBtnPressed()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        //self.tv_description.centerVertically()
    }
    
}
