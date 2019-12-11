//
//  WhatIsYamigu.swift
//  yamigu
//
//  Created by ph7164 on 11/12/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class WhatIsYamigu: UIViewController {
    
    @IBOutlet weak var button_whatis: UIButton!
    @IBOutlet weak var button_safe: UIButton!
    @IBOutlet weak var button_review: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func whatisBtnPressed(_ sender: Any) {
        button_safe.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_review.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_whatis.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        
        imageView.image = UIImage(named: "image_more_whatis1")
        viewHeight.constant = 601
    }
    
    @IBAction func safeBtnPressed(_ sender: Any) {
        button_safe.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        button_review.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_whatis.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        
        imageView.image = UIImage(named: "image_more_whatis2")
        viewHeight.constant = 682
    }
    
    @IBAction func reviewBtnPressed(_ sender: Any) {
        button_safe.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        button_review.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        button_whatis.setTitleColor(UIColor(rgb: 0x707070), for: .normal)
        
        imageView.image = UIImage(named: "image_more_whatis3")
        viewHeight.constant = 1029
    }
}
