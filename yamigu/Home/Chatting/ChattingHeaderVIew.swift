//
//  ChattingHeaderVIew.swift
//  yamigu
//
//  Created by Yoon on 11/11/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class ChattingHeaderVIew: UICollectionReusableView {
    @IBOutlet weak var image_profile: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_time: UILabel!
    @IBOutlet weak var label_openbyName: UILabel!
    @IBOutlet weak var label_openbyDepartment: UILabel!
    @IBOutlet weak var label_partnerName: UILabel!
    @IBOutlet weak var label_partnerDepartment: UILabel!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_place: UILabel!
    @IBOutlet weak var label_type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
