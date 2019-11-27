//
//  RegisterVC_1.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoCommon
import KakaoOpenSDK
import WebKit

class RegisterVC_1: UIViewController , WKNavigationDelegate{
    
    var isLogined = true
    var webView = WKWebView()
    
    var userDict = Dictionary<String,Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLogined = true
    }
    
    @IBAction func verificationBtnPressed(_ sender: Any) {
        if !isLogined {
            //performSegue(withIdentifier: "segue_register2", sender: self)
            webView.frame = self.view.frame
            self.view.addSubview(webView)
            webView.navigationDelegate = self
            
            guard let url = URL(string:"http://106.10.39.154:5000/checkplus_main") else {return}

            let request = URLRequest(url: url)

            webView.load(request)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let userNickname = userDictionary["nickname"] {
            if "\(userNickname)" == "<null>" {
                
            } else {
                DispatchQueue.main.async {
                    let loginVC = self.presentingViewController as! LoginVC
                    
                    let access_token = (KOSession.shared()?.token?.accessToken)!
                    loginVC.postRequest("http://106.10.39.154:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
                }
                //self.dismiss(animated: false, completion: nil)
                self.dismiss(animated: false, completion: nil)
                
                
            }
        }
        
        let access_token = (KOSession.shared()?.token?.accessToken)!
        
        if access_token != nil {
            //self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            self.getUserInfo(urlString: "http://106.10.39.154:9999/api/user/info/")
        } else {
            self.isLogined = false
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
                        let loginVC = self.presentingViewController as! LoginVC
                        
                        let access_token = (KOSession.shared()?.token?.accessToken)!
                        loginVC.postRequest("http://106.10.39.154:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
                        
                        self.dismiss(animated: false, completion: nil)
                        //self.navigationController!.dismiss(animated: false, completion: nil)
                        
                    }
                } catch {
                    print(error)
                    
                    
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
                        if "\(newValue["nickname"]!)" == "<null>" {
                            print("is null")
                            self.isLogined = false
                        }
                        else if newValue["nickname"] == nil {
                            self.isLogined = false
                        } else {
                            let loginVC = self.presentingViewController as! LoginVC
                            
                            let access_token = (KOSession.shared()?.token?.accessToken)!
                            loginVC.postRequest("http://106.10.39.154:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
                            
                            self.dismiss(animated: false, completion: nil)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            //do something with headers
            //print(headers)
            
            
        }
        decisionHandler(.allow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_register2" {
            let desVC:RegisterVC_2 = segue.destination as! RegisterVC_2
            desVC.userDict = self.userDict
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByTagName('pre')[0].innerHTML") { innerHTML, error in
            
            if let html = innerHTML {
                let htmlString = html as! String
                let data = htmlString.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                       print(jsonArray) // use the json here
                        self.userDict = jsonArray
                        
                        let birthDayString = jsonArray["birthdate"] as! String
                        self.userDict["real_name"] = jsonArray["name"] as! String
                        self.userDict["phone"] = jsonArray["mobileno"] as! String
                        self.userDict["gender"] = Int(jsonArray["gender"] as! String)
                        
                        self.userDict["age"] = self.calcAge(birthday: birthDayString)
                        
                        self.performSegue(withIdentifier: "segue_register2", sender: self)
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            }
            
            
        }
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyyMMdd"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let calcMont = calendar.components(.month, from: birthdayDate!, to: now, options: [])
    
        let age = calcAge.year
        return age!
    }
    
}

