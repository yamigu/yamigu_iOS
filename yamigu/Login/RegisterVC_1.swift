//
//  RegisterVC_1.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class RegisterVC_1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func verificationBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "segue_register2", sender: self)
    }
    

}
