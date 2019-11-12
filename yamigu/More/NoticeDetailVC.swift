//
//  NoticeDetailVC.swift
//  yamigu
//
//  Created by ph7164 on 11/11/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class NoticeDetailVC: UIViewController {
    
    @IBOutlet weak var label_title: UILabel!
    
    @IBOutlet weak var textview_details: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "공지사항"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

    }
    

   
}
