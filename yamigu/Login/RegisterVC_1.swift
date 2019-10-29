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

class RegisterVC_1: UIViewController {
    
    var isLogined = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLogined = true
    }
    
    @IBAction func verificationBtnPressed(_ sender: Any) {
        if !isLogined {
            performSegue(withIdentifier: "segue_register2", sender: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let access_token = (KOSession.shared()?.token?.accessToken)!
        
        if access_token != nil {
            self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            
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
                        
                        self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print(error)
                    
                    
                }
            }
            }.resume()
    }
    
}
