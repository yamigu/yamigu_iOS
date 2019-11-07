//
//  SettingVC.swift
//  yamigu
//
//  Created by ph7164 on 07/11/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var switch_pushNoti: UISwitch!
    @IBOutlet weak var switch_chattingNoti: UISwitch!
    
    @IBOutlet weak var view_notices: UIView!
    @IBOutlet weak var view_privacyStatements: UIView!
    @IBOutlet weak var view_serviceAccessTerms: UIView!
    
    @IBOutlet weak var view_logout: UIView!
    @IBOutlet weak var button_withdrawal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))

        logoutAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(logoutAlert, animated: true, completion: nil)
    }

}

extension SettingVC {
    func setupUI() {
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view_logout.addGestureRecognizer(logoutTap)
    }
}
