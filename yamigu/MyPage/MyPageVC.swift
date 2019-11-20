//
//  MyPageVC.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var image_profile: UIImageView!
    @IBOutlet weak var label_belong: UILabel!
    @IBOutlet weak var label_department: UILabel!
    
    @IBOutlet weak var label_verified: UILabel!
    @IBOutlet weak var view_blur: UIView!
    @IBOutlet weak var button_verifyBelong: UIButton!
    
    @IBOutlet weak var button_comp: UIBarButtonItem!
    @IBOutlet weak var button_cancel: UIBarButtonItem!
    
    @IBOutlet weak var tf_name: UITextField!
    
    @IBOutlet weak var button_change: UIButton!
    @IBOutlet weak var view_underline: UIView!
    
    @IBOutlet weak var label_able: UILabel!
    
    @IBOutlet weak var button_notification: UIButton!
    @IBOutlet weak var button_tickets: UIButton!
    
    var userDict = Dictionary<String, Any>()
    
    var isStudent = true
    var isChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf_name.delegate = self

        view_underline.isHidden = true
        button_comp.isEnabled = false
        button_cancel.isEnabled = false
        
        label_able.isHidden = true
        
        button_comp.tintColor = .clear
        button_cancel.tintColor = .clear
        
        tf_name.isUserInteractionEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tf_name.text = "\(userDictionary["nickname"] as! String)(\(userDictionary["age"]!))"
        
        self.getUserInfo(urlString: "http://106.10.39.154:9999/api/user/info/")
    }
    
    @IBAction func changeBtnPressed(_ sender: Any) {
        tf_name.text = ""
        
        if isChanged {
            isChanged = false
            
        } else {
            setAble()
        }
    }
    @IBAction func compBtnPressed(_ sender: Any) {
        checkNickname(urlString: "http://106.10.39.154:9999/api/user/validation/nickname/\(self.tf_name.text!)", isComp: true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        tf_name.text = "\(userDictionary["nickname"] as! String)(\(userDictionary["age"]!))"
        setDisable()
    }
    
    func setDisable() {
        isChanged = false
        
        button_change.isHidden = false
        view_underline.isHidden = true
        button_comp.isEnabled = false
        button_cancel.isEnabled = false
        
        label_able.isHidden = true
        
        button_comp.tintColor = .clear
        button_cancel.tintColor = .clear
        
        tf_name.isUserInteractionEnabled = false
        
        
        tf_name.text = "\(userDictionary["nickname"] as! String)(\(userDictionary["age"]!))"
    }
    
    func setAble() {
        isChanged = true
        
        button_change.isHidden = true
        view_underline.isHidden = false
        button_comp.isEnabled = true
        button_cancel.isEnabled = true
        
        //label_able.isHidden = false
        
        button_comp.tintColor = .black
        button_cancel.tintColor = .black
        
        tf_name.isUserInteractionEnabled = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nickName = String(utf8String: self.tf_name.text!.cString(using: .utf8)!)
        print("nickName = \(nickName!)")
        var urlString = "http://106.10.39.154:9999/api/user/validation/nickname/\(nickName!)"
        let str_url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        urlString = String(utf8String: str_url.cString(using: .utf8)!)!
        checkNickname(urlString: urlString, isComp: false)
        
        return true
    }
    
    func checkNickname(urlString : String, isComp : Bool) {
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "get"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authroization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            print(response)
            
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)
                    //print(str)
                    
                    DispatchQueue.main.async {
                        //
                        if str.contains("true") {
                            print(str)
                            
                            self.label_able.isHidden = false
                            self.label_able.textColor = UIColor(rgb: 0x3129FF)
                            self.label_able.text = "사용 가능 합니다."
                            if isComp {
                                self.postRequest("http://106.10.39.154:9999/api/user/change/nickname/", bodyString:"nickname=\(self.tf_name.text!)")
                            }
                        } else {
                            self.label_able.isHidden = false
                            self.label_able.textColor = UIColor(rgb: 0xFF0000)
                            self.label_able.text = "사용 불가능 합니다."
                        }
                    }
                }
            }else{
                print("data nil")
            }
        })
        task.resume()
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
                    
                    self.userDict = newValue
                    
                    DispatchQueue.main.async {
                        if "\(newValue["nickname"]!)" == "<null>" {
                            print("is null")
                        }
                        else if newValue["nickname"] == nil {
                        }
                        else {
                            self.tf_name.text = "\(newValue["nickname"] as! String)(\(newValue["age"]!))"
                            self.label_belong.text = newValue["belong"] as? String
                            self.label_department.text = newValue["department"] as? String
                            
                            
                            if self.userDict["openby_profile"] != nil {
                                if let imageUrl = URL(string: "\(self.userDict["openby_profile"]!)") {
                                    
                                    self.image_profile.downloaded(from: imageUrl)
                                    self.image_profile.contentMode = .scaleAspectFill
                                }
                            } else {
                                self.image_profile.image = UIImage(named: "sample_profile")
                            }
                            
                            if newValue["user_certified"] as? Int != 2 {
                                self.label_verified.isHidden = true
                                self.view_blur.isHidden = false
                                self.button_verifyBelong.isHidden = false
                                
                                if newValue["user_certified"] as? Int == 1 {
                                    self.button_verifyBelong.setTitle("인증 진행중입니다", for: .normal)
                                }
                                else if newValue["user_certified"] as? Int == 0 {
                                    
                                }
                            } else {
                                self.label_verified.isHidden = false
                                self.view_blur.isHidden = true
                                self.button_verifyBelong.isHidden = true
                            }
                        }
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
                        self.label_able.isHidden = true
                        userDictionary["nickname"] = self.tf_name.text!
                        self.setDisable()
                    }
                }
            }else{
                print("data nil")
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_certi" {
            let desVC: CertiVC = segue.destination as! CertiVC
            desVC.userDict = self.userDict
            desVC.isStudent = self.isStudent
        }
    }
    
    
    @IBAction func certiBelongBtnPressed(_ sender: Any) {
        isStudent = self.userDict["is_student"] as! Bool
        
        self.performSegue(withIdentifier: "segue_certi", sender: self)
    }
    
    
    @IBAction func notiBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_notification", sender: self)
    }
    
    @IBAction func ticketBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_tickets", sender: self)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
    }
    @IBAction func talkBtnPressed(_ sender: Any) {
        
    }
}
