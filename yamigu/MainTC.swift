//
//  MainTC.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class MainTC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func adjustImageAndTitleOffsetsForButton (button: UIButton) {
        
        let spacing: CGFloat = 6.0
        let imageSize = button.imageView!.frame.size
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        let titleSize = button.titleLabel!.frame.size
        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }

}
