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

class LoginVC: UIViewController {

    @IBOutlet weak var btn_question: UIButton!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_description.text = "학교와 직장이 인증된 이성과\n일주일안에 미팅하기"
    }

    override func viewWillAppear(_ animated: Bool) {
        print("\(KOSession.shared()?.token?.accessToken)")
        
        if KOSession.shared()?.token?.accessToken != nil {
            //self.performSegue(withIdentifier: "segue_agreement", sender: self)
            //self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func questionPressed(_ sender: Any) {
    }
    
    @IBAction func kakaoLoginPressed(_ sender: Any) {
        //
        KOSession.shared()?.close()
        
        KOSession.shared()?.open(completionHandler: { (error) in
            if (KOSession.shared()?.isOpen())! {
                let access_token = (KOSession.shared()?.token?.accessToken)!
                self.postRequest("http://147.47.208.44:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            } else {
                
            }
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
                        
                        self.performSegue(withIdentifier: "segue_agreement", sender: self)
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    //self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
            }.resume()
    }
}
