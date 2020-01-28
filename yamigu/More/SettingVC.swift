//
//  SettingVC.swift
//  yamigu
//
//  Created by ph7164 on 07/11/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoCommon
import KakaoOpenSDK

class SettingVC: UIViewController {
    
    @IBOutlet weak var switch_pushNoti: UISwitch!
    @IBOutlet weak var switch_chattingNoti: UISwitch!
    
    @IBOutlet weak var view_notices: UIView!
    @IBOutlet weak var view_privacyStatements: UIView!
    @IBOutlet weak var view_serviceAccessTerms: UIView!
    
    @IBOutlet weak var view_logout: UIView!
    @IBOutlet weak var button_withdrawal: UIButton!
    
    @IBOutlet weak var view_privacyStatementsDetail: UIView!
    @IBOutlet weak var view_serviceAccessTermsDetail: UIView!
    
    let blackBackgroundView : UIView = {
        let view = UIView()
        
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.makeToastActivity(.center)
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blackBackgroundView.frame = self.view.frame
        self.view.addSubview(blackBackgroundView)
        self.getUserInfo(urlString: "http://13.124.126.30:9999/api/user/info/")
    }
    
    @IBAction func switch_pushNoti(_ sender: UISwitch) {
        if !switch_pushNoti.isOn {
             self.postRequest("http://13.124.126.30:9999/api/turn_off/push/")
            if switch_chattingNoti.isOn {
                switch_chattingNoti.isOn = false
                self.postRequest("http://13.124.126.30:9999/api/turn_off/chat/")
            }
        }  else {
            self.postRequest("http://13.124.126.30:9999/api/turn_on/push/")
        }
        
        
    }
    
    @IBAction func switch_chattingNoti(_ sender: UISwitch) {
        if !switch_pushNoti.isOn {
            switch_chattingNoti.isOn = false
            
        } else {
            self.postRequest("http://13.124.126.30:9999/api/turn_off/chat/")
        }
        
        if switch_chattingNoti.isOn {
            self.postRequest("http://13.124.126.30:9999/api/turn_on/chat/")
        } else {
            self.postRequest("http://13.124.126.30:9999/api/turn_off/chat/")
        }
        
    }
    
    @objc func privacyStatementsTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view_privacyStatementsDetail.isHidden = false
    }
    
    @objc func serviceAccessTermsTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view_serviceAccessTermsDetail.isHidden = false
    }
    
    @objc func noticeTap(_ sender: UITapGestureRecognizer? = nil) {
        self.performSegue(withIdentifier: "segue_notice", sender: self)
    }
    
    @objc func logoutTap(_ sender: UITapGestureRecognizer? = nil) {
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
           
            
            if let kakaoToken = KOSession.shared()?.token?.accessToken {
                 self.postRequest("http://13.124.126.30:9999/api/auth/logout/")
            } else {
                do {
                    try KeychainItem(service: "party.yamigu.www.com", account: "userIdentifier").deleteItem()
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    
                }
            }
            
            
        }))

        logoutAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(logoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func withdrawalBtnPressed(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴시 3개월간 재가입이 불가능합니다.\n정말 탈퇴하시겠습니까?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "회원탈퇴", style: .default, handler: { (action: UIAlertAction!) in
            if let kakaoToken = KOSession.shared()?.token?.accessToken {
                 self.postRequest("http://13.124.126.30:9999/api/auth/logout/")
            } else {
                do {
                    try KeychainItem(service: "party.yamigu.www.com", account: "userIdentifier").deleteItem()
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    
                }
            }
            
            self.postRequest("http://13.124.126.30:9999/api/auth/withdrawal/")
        }))

        logoutAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(logoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func closeDetailBtnPressed(_ sender: Any) {
        self.view_privacyStatementsDetail.isHidden = true
        self.view_serviceAccessTermsDetail.isHidden = true
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
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        
                        guard let session = KOSession.shared() else { return }
                        session.logoutAndClose { (success, error) in
                          if success {
                            print("logout success.")
                            self.dismiss(animated: true, completion: nil)
                          } else {
                            print(error?.localizedDescription)
                          }
                        }
                                                

                        
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
        
        let noticeTap = UITapGestureRecognizer(target: self, action: #selector(self.noticeTap(_:)))
        self.view_notices.addGestureRecognizer(noticeTap)
        
        let privacyStatementsTap = UITapGestureRecognizer(target: self, action: #selector(self.privacyStatementsTap(_:)))
        self.view_privacyStatements.addGestureRecognizer(privacyStatementsTap)
        
        let serviceAccessTermsTap = UITapGestureRecognizer(target: self, action: #selector(self.serviceAccessTermsTap(_:)))
        self.view_serviceAccessTerms.addGestureRecognizer(serviceAccessTermsTap)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.view_privacyStatementsDetail.isHidden = true
        self.view_serviceAccessTermsDetail.isHidden = true
        
        
    }
    
    func getUserInfo(urlString : String) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "get"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            print(response)
            
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    userDictionary = newValue
                    DispatchQueue.main.async {
                        let pushState = newValue["push_on"] as! Bool
                        let chatState = newValue["chat_on"] as! Bool
                        
                        if pushState {
                            self.switch_pushNoti.isOn = true
                        } else {
                            self.switch_pushNoti.isOn = false
                        }
                        
                        if chatState {
                            self.switch_chattingNoti.isOn = true
                        } else {
                            self.switch_chattingNoti.isOn = false
                        }
                        
                        self.blackBackgroundView.removeFromSuperview()
                        
                    }
                } catch {
                    print(error)
                    
                }
            }
            
        })
        task.resume()
    }
    
    func postRequest(_ urlString: String, bodyString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //[serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        request.httpBody = body
        //let data : Data = NSKeyedArchiver.archivedData(withRootObject: self.userDict)
        //JSONSerialization.isValidJSONObject(self.userDict)
        //request.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)
                    print(str)
                    
                    DispatchQueue.main.async {
                    }
                }
            }else{
                print("data nil")
            }
        }.resume()
    }
    
    
}
