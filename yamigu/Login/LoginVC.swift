//
//  LoginVC.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var btn_question: UIButton!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_description.text = "학교와 직장이 인증된 이성과\n일주일안에 미팅하기"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func questionPressed(_ sender: Any) {
    }
    
    @IBAction func kakaoLoginPressed(_ sender: Any) {
    }
}
