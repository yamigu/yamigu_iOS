//
//  MyPageVC.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var button_comp: UIBarButtonItem!
    @IBOutlet weak var button_cancel: UIBarButtonItem!
    
    @IBOutlet weak var tf_name: UITextField!
    
    @IBOutlet weak var button_change: UIButton!
    @IBOutlet weak var view_underline: UIView!
    
    @IBOutlet weak var label_able: UILabel!
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
        checkNickname(urlString: "http://147.47.208.44:9999/api/user/validation/nickname/\(self.tf_name.text!)", isComp: true)
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
        
        checkNickname(urlString: "http://147.47.208.44:9999/api/user/validation/nickname/\(self.tf_name.text!)", isComp: false)
        
        return true
    }
    
    func checkNickname(urlString : String, isComp : Bool) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
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
                                self.postRequest("http://147.47.208.44:9999/api/user/change/nickname/", bodyString:"nickname=\(self.tf_name.text!)")
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
    
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
    }
    @IBAction func talkBtnPressed(_ sender: Any) {
        
    }
}
