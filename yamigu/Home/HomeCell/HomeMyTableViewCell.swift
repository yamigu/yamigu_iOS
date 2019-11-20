//
//  HomeMyTableViewCell.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

protocol HomeTalbeViewDelegate: class {
    func viewApplyList(index: Int)
    func viewWatingList(index: Int)
    func edit(index: Int)
    func chat(index: Int)
}

class HomeMyTableViewCell: UITableViewCell {

    weak var delegate : HomeTalbeViewDelegate?
    var index : Int!
    @IBOutlet weak var constraint_bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var label_matchingDepart: UILabel!
    @IBOutlet weak var label_matchingName: UILabel!
    @IBOutlet weak var label_chattingCount: UILabel!
    @IBOutlet weak var label_chattingTime: UILabel!
    @IBOutlet weak var label_lastChat: UILabel!
    @IBOutlet weak var label_dday: UILabel!
    @IBOutlet weak var label_day: UILabel!
    @IBOutlet weak var label_month: UILabel!
    @IBOutlet weak var label_type: UILabel!
    @IBOutlet weak var label_place: UILabel!
    @IBOutlet weak var label_isMatched: UILabel!
    @IBOutlet weak var label_isWating: UILabel!
    @IBOutlet weak var label_teamCount: UILabel!
    @IBOutlet weak var button_applyTeam: UIButton!
    @IBOutlet weak var button_watingTeam: UIButton!
    @IBOutlet weak var button_edit: UIButton!
    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var view_backgroundMonth: UIView!
    @IBOutlet weak var image_bottom: UIImageView!
    @IBOutlet weak var image_view_bar1: UIImageView!
    @IBOutlet weak var image_view_bar2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        //self.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)

        self.view_bottom.isHidden = false
        
        
    }
    
    override func prepareForReuse() {
        self.constraint_bottomHeight.constant = 40.0
        self.label_matchingDepart.isHidden = false
        self.label_matchingName.isHidden = false
        self.label_chattingTime.isHidden = false
        self.label_lastChat.isHidden = false
        self.label_day.isHidden = false
        self.label_type.isHidden = false
        self.label_isMatched.isHidden = false
        self.label_isWating.isHidden = false
        self.button_applyTeam.isHidden = false
        self.button_edit.isHidden = false
        self.view_bottom.isHidden = false

        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    @IBAction func chatBtnPressed(_ sender: Any) {
        delegate?.chat(index: index)
    }
    
    @IBAction func applyTeamBtnPressed(_ sender: Any) {
        delegate?.viewApplyList(index: index)
    }
    @IBAction func watingTeamBtnPressed(_ sender: Any) {
        delegate?.viewWatingList(index: index)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        delegate?.edit(index: index)
    }
    
}
