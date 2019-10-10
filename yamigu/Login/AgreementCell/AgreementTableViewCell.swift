//
//  AgreementTableViewCell.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class AgreementTableViewCell: UITableViewCell {

    @IBOutlet weak var image_text: UIImageView!
    @IBOutlet weak var image_agreement: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            image_agreement.image = UIImage(named: "icon_agreement_selected")
            self.backgroundColor = .clear
        } else {
            image_agreement.image = UIImage(named: "icon_agreement")
        }
        
    }
    
    
    
}
