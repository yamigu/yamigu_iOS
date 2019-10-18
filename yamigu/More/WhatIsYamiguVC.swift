//
//  WhatIsYamiguVC.swift
//  yamigu
//
//  Created by Yoon on 18/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class WhatIsYamiguVC: UIViewController {

    @IBOutlet weak var button_safe: UIButton!
    @IBOutlet weak var button_review: UIButton!
    @IBOutlet weak var button_whatIs: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func safeBtnPressed(_ sender: Any) {
        button_safe.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        button_review.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_whatIs.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        
        imageView.image = UIImage(named: "image_more_whatis2")
        height.constant = 682
    }
    @IBAction func reviewBtnPrssed(_ sender: Any) {
        button_safe.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_review.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        button_whatIs.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        
        imageView.image = UIImage(named: "image_more_whatis3")
        height.constant = 1029
        
    }
    @IBAction func whatisBtnPressed(_ sender: Any) {
        button_safe.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_review.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_whatIs.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        
        imageView.image = UIImage(named: "image_more_whatis1")
        height.constant = 601
    }
    
}
