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
    
    @objc func logoutTap(_ sender: UITapGestureRecognizer? = nil) {
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.postRequest("http://106.10.39.154:9999/api/auth/logout/")
        }))

        logoutAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(logoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func withdrawalBtnPressed(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴시 3개월간 재가입이 불가능합니다.\n정말 탈퇴하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "회원탈퇴", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))

        logoutAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(logoutAlert, animated: true, completion: nil)
    }
    

    func postRequest(_ urlString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, String> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        //self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print(error)
                    
                    
                }
            }
        }.resume()
    }
}

extension SettingVC {
    func setupUI() {
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.logoutTap(_:)))
        self.view_logout.addGestureRecognizer(logoutTap)
    }
    
    
}
