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
    @IBOutlet weak var view_bottom: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
    
        
        
    }
    
    override func prepareForReuse() {
        self.constraint_bottomHeight.constant = 44.0
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
