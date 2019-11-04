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
 
        
        print("access token = \(KOSession.shared()?.token?.accessToken)")
        if KOSession.shared()?.token?.accessToken != nil {
            let access_token = (KOSession.shared()?.token?.accessToken)!
            print("access token2 = \(access_token)")
            self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            
            //performSegue(withIdentifier: "segue_onboarding", sender: self)
        } else {
            
            performSegue(withIdentifier: "segue_onboarding", sender: self)
        }
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
                
                //print(res)
                
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
                        authKey = newValue["key"]!
                        self.getUserInfo(urlString: "http://147.47.208.44:9999/api/user/info/")
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    self.performSegue(withIdentifier: "segue_onboarding", sender: self)
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
                                self.performSegue(withIdentifier: "segue_main", sender: self)
                                
                                
                            }
                        })
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
            
        })
        task.resume()
    }
}
