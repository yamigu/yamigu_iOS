//
//  LoginVC.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoCommon
import KakaoOpenSDK
import AuthenticationServices



class LoginVC: UIViewController {
    
    @IBOutlet weak var btn_question: UIButton!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_login: UIButton!
    var appleToken : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_description.text = "학교와 직장이 인증된 이성과\n일주일안에 미팅하기"
        
        if #available(iOS 13.0, *) {
                
                let btn_appleLogin  = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
                btn_appleLogin.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(btn_appleLogin)
                
                btn_appleLogin.bottomAnchor.constraint(equalTo: self.btn_login.topAnchor, constant: -10.0).isActive = true
                btn_appleLogin.leadingAnchor.constraint(equalTo: self.btn_login.leadingAnchor, constant: 0).isActive = true
                btn_appleLogin.trailingAnchor.constraint(equalTo: self.btn_login.trailingAnchor, constant: 0).isActive = true
                btn_appleLogin.heightAnchor.constraint(equalTo: self.btn_login.heightAnchor, constant: 0).isActive = true
                
        
                btn_appleLogin.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(KOSession.shared()?.token?.accessToken)")
        
        if KOSession.shared()?.token?.accessToken != nil {
            //self.performSegue(withIdentifier: "segue_agreement", sender: self)
            //self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            
            
            if let userNickname = userDictionary["nickname"] {
                if "\(userNickname)" == "<null>" {
                    
                } else {
                    self.dismiss(animated: false, completion: nil)
                }
                
            }
        }
        
        
    }
    
    @IBAction func questionPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_whatIsYamigu", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_agreement" {
            if let token = self.appleToken {
                let des = segue.destination as! UINavigationController
                let reg = des.topViewController as! RegisterVC_1
                reg.appleToken = self.appleToken
            }
           
        }
    }
    
    @IBAction func kakaoLoginPressed(_ sender: Any) {
        //
        KOSession.shared()?.close()
        
        
        KOSession.shared()?.open(completionHandler: { (error) in
            
            print("error = \(error)")
            
            if error == nil {
                let access_token = (KOSession.shared()?.token?.accessToken)!
                self.postRequest("http://106.10.39.154:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            }
            
            
            /*if (KOSession.shared()?.isOpen())! {
                
            } else {
                
            }*/
            
        })
    }
    
    func postRequest(_ urlString: String, bodyString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        request.httpBody = body
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        authKey = newValue["key"]! as! String
                        self.getUserInfo(urlString: "http://106.10.39.154:9999/api/user/info/")
                        
                        
                        
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    //self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
            }.resume()
    }
    
    func postRequest2(_ urlString: String, bodyString: String, json: [String: Any]){
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
            var jsonString = String(data: data, encoding: .utf8) {
            //jsonString = jsonString.replacingOccurrences(of: "'", with: "")
            //jsonString = jsonString.replacingOccurrences(of: " ", with: "")
            //jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
            let data = jsonString.data(using: .utf8, allowLossyConversion: false)
            request.httpBody = data
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        authKey = newValue["key"]! as! String
                        do {
                            try KeychainItem(service: "party.yamigu.www.com", account: "userIdentifier").saveItem(authKey)
                        } catch {
                            print("Unable to save userIdentifier to keychain.")
                        }
                        self.getUserInfo(urlString: "http://106.10.39.154:9999/api/user/info/")
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    //self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
            }.resume()
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
                    
                    DispatchQueue.main.async {
                        userDictionary = newValue
                        
                        print("newValue = \(newValue)")
                        print("nickname = \(userDictionary["nickname"] ?? "<null>")")
                        if let nick = userDictionary["nickname"] {
                
                            if ("\(userDictionary["nickname"] ?? "<null>")") != "<null>" {
                                //self.dismiss(animated: false, completion: nil)
                                self.performSegue(withIdentifier: "segue_loginCheck", sender: self)
                                self.navigationController?.isNavigationBarHidden = true
                            } else {
                                self.performSegue(withIdentifier: "segue_agreement", sender: self)
                            }
                        } else {
                             self.performSegue(withIdentifier: "segue_agreement", sender: self)
                        }
                        
                        
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    //self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
            
        })
        task.resume()
    }
}

@available(iOS 13.0, *)
    extension LoginVC : ASAuthorizationControllerDelegate, ASAuthorizationProvider, ASAuthorizationControllerPresentationContextProviding {
        
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    @objc func signInButtonPressed() {
        // First you create an apple id provider request with the scope of full name and email
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        // Instanstiate and configure the authorization controller
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self

        // Perform the request
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let authError = ASAuthorizationError(_nsError: error as NSError)
        switch authError.code {
            // Add cases and handle errors
        case .unknown: break
            
        case .canceled: break
            
        case .invalidResponse: break
            
        case .notHandled: break
            
        case .failed: break
            
        @unknown default: break
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let data = credential.authorizationCode, let code = String(data: data, encoding: .utf8) {
                
                // Handle response
                let access_token = code
                print(code)
                self.appleToken = access_token
                let json = ["access_token": code]
                
                
                
                self.postRequest2("http://106.10.39.154:9999/api/oauth/apple/", bodyString: "", json: json)
            } else {
                // Handle missing authorization code ...
            }
        }
    }
    
    func exchangeCode(_ code: String, handler: (String?, Error?) -> Void) {
        // Call your backend to exchange an API token with the code.
        
    }
    
    
    
}

