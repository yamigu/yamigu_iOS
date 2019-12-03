//
//  LoginCheckVC.swift
//  yamigu
//
//  Created by Yoon on 16/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import KakaoCommon
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import Firebase
import AuthenticationServices


var authKey = ""
var userDictionary = Dictionary<String, Any>()
class LoginCheckVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        /*KOSession.shared()?.logoutAndClose(completionHandler: { (success, error) in
            if success {
                print("access token = \(KOSession.shared()?.token?.accessToken)")
                if KOSession.shared()?.token?.accessToken != nil {
                    let access_token = (KOSession.shared()?.token?.accessToken)!
                    print("access token2 = \(access_token)")
                    self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
                    
                    //performSegue(withIdentifier: "segue_onboarding", sender: self)
                } else {
                    
                    self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            } else {
                
            }
        })*/
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    break
                case .revoked:
                    // The Apple ID credential is revoked.
                    break
                case .notFound:
                    break
                    // No credential was found, so show the sign-in UI.
                    
                default:
                    break
                }
            }
        }
        
        
        print("access token = \(KOSession.shared()?.token?.accessToken)")
        if KOSession.shared()?.token?.accessToken != nil {
            var access_token = (KOSession.shared()?.token?.accessToken)!
            print("access token2 = \(access_token)")
            //access_token = (KOSession.shared()?.refreshToken)!
            //access_token = KOSession.
            
            
            KOSession.shared()?.refreshAccessToken(completionHandler: { (error) in
                
                print("kakao error = \(error)")
                
                if error == nil {
                    access_token = (KOSession.shared()?.token?.accessToken)!
                    print("refresh token = \(access_token)")
                    
                    let json = ["access_token":access_token]
                    
                    DispatchQueue.main.async {
                        self.postRequest("http://106.10.39.154:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)", json: json)
                    }
                }
            })
            
            
            //self.postRequest2("http://147.47.208.44:9999/api/fcm/register_device/", bodyString: "registration_id=\(token)&type=iOS")
            //performSegue(withIdentifier: "segue_onboarding", sender: self)
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segue_onboarding", sender: self)
            }
            
        }
    }
    
    func postRequest2(_ urlString: String, bodyString: String, json: [String: Any]){
       
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
  
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
            let jsonString = String(data: data, encoding: .utf8) {
            print("jsonString = \(jsonString)")
            request.httpBody = jsonString.data(using: .utf8)
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
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func postRequest(_ urlString: String, bodyString: String, json: [String: Any]){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let jsonString = String(data: data, encoding: .utf8) {
            request.httpBody = jsonString.data(using: .utf8)
        }
        
        
        
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
                        // 동작 실행
                        var token = ""
                        authKey = newValue["key"]!
                        
                        
                        self.getUserInfo(urlString: "http://106.10.39.154:9999/api/user/info/")
                        
                        InstanceID.instanceID().instanceID { (result, error) in
                            if let error = error {
                                print("Error fetching remote instance ID: \(error)")
                            } else if let result = result {
                                print("Remote instance ID token: \(result.token)")
                                print("Remote InstanceID token: \(result.token)")
                                token = result.token
                                
                                var data = [String: Any]()
                                data["registration_id"] = token
                                data["type"] = "ios"
                                
                                self.postRequest2("http://106.10.39.154:9999/api/fcm/register_device/", bodyString: "registration_id=\(token)&type=ios", json: data)
                            }
                        }
                        
                        
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                    }
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
                        // 동작 실행
                        //print(newValue)
                        userDictionary = newValue
                        print("firebase Auth = \(userDictionary["firebase_token"])")
                        
                        
                        Auth.auth().signIn(withCustomToken: "\(userDictionary["firebase_token"]!)", completion: { (result, error) in
                            
                            print(error)
                            
                            
                            if error == nil {
                                print("firebase Auth = \(Auth.auth().currentUser?.uid)")
                                DispatchQueue.main.async {
                                    if let userNickname = userDictionary["nickname"] {
                                        if "\(userNickname)" == "<null>" {
                                            self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                                        } else {
                                            self.performSegue(withIdentifier: "segue_main", sender: self)
                                        }
                                    } else {
                                        self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                        })
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                    }
                    
                }
            }
            
        })
        task.resume()
    }
}
