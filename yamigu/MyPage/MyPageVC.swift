//
//  MyPageVC.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoPlusFriend
import KakaoLink
import KakaoMessageTemplate

class MyPageVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var button_changeProfileImage: UIButton!
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
    
    @IBOutlet weak var label_inviteCode: UILabel!
    var userDict = Dictionary<String, Any>()
    
    var isStudent = 1
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
        tf_name.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        //viewHeightConstraint.constant = scrollContentView.content + 30
        print("view height: \(viewHeightConstraint.constant)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tf_name.text = "\(userDictionary["nickname"] as! String)(\(userDictionary["age"]!))"
        self.button_notification.setTitle(" \(alarmCount)", for: .normal)
        
        self.getUserInfo(urlString: "http://106.10.39.154:9999/api/user/info/")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))

        image_profile.addGestureRecognizer(tapGesture)
        
        if "\(userDictionary["nickname"]!)" == "<null>" {
            print("is null")
        }
        else if userDictionary["nickname"] == nil {
        }
        else {
            self.tf_name.text = "\(userDictionary["nickname"] as! String)(\(userDictionary["age"]!))"
            self.label_belong.text = userDictionary["belong"] as? String
            self.label_department.text = userDictionary["department"] as? String
            self.button_tickets.setTitle("\(userDictionary["ticket"]!)", for: .normal)
            self.label_inviteCode.text = "\(userDictionary["invite_code"]!)"
            if self.userDict["image"] != nil {
                if let imageUrl = URL(string: "\(userDictionary["image"]!)") {
                    
                    self.image_profile.downloaded(from: imageUrl)
                    self.image_profile.contentMode = .scaleAspectFill
                }
            } else {
                self.image_profile.image = UIImage(named: "sample_profile")
            }
            
            if userDictionary["user_certified"] as? Int != 2 {
                self.label_verified.isHidden = true
                self.view_blur.isHidden = false
                self.button_verifyBelong.isHidden = false
                
                if userDictionary["user_certified"] as? Int == 1 {
                    self.button_verifyBelong.setTitle("인증 진행중입니다", for: .normal)
                }
                else if userDictionary["user_certified"] as? Int == 0 {
                    
                }
            } else {
                self.label_verified.isHidden = false
                self.view_blur.isHidden = true
                self.button_verifyBelong.isHidden = true
            }
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {

            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            
            self.present(image, animated: true)
        }
    }
    
    @IBAction func changeProfileBtnPressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.image_profile.image = image
            
            var jsonImg = Dictionary<String, Data>()
            //jsonImg["uploaded_file"] = self.imageView_certi.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            jsonImg.updateValue(self.image_profile.image!.jpegData(compressionQuality: 0.1)!, forKey: "uploaded_file")
            
            self.postRequestImage("http://106.10.39.154:9999/api/user/change/avata/", bodyString: "uploaded_file=", json: jsonImg)
        } else {
            // error
        }
        
        self.dismiss(animated: true, completion: nil)
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
        let nickName = String(utf8String: self.tf_name.text!.cString(using: .utf8)!)
        print("nickName = \(nickName!)")
        var urlString = "http://106.10.39.154:9999/api/user/validation/nickname/\(nickName!)"
        let str_url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        urlString = String(utf8String: str_url.cString(using: .utf8)!)!
        checkNickname(urlString: urlString, isComp: true)
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
        //let nickName = String(utf8String: self.tf_name.text!.cString(using: .utf8)!)
        
        
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var nickName = String(utf8String: ((textField.text?.cString(using: .utf8))!))!
        /*nickName = String(utf8String: nickName.cString(using: .utf8)!)!
        if string == "" {
            nickName.removeLast()
        }*/
        //print("nickName = \(nickName)")
        //print("replacementString = \(string)")
        
        print("nickNameLength = \(nickName.utf8.count)")
        var urlString = "http://106.10.39.154:9999/api/user/validation/nickname/\(nickName)"
        let str_url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        urlString = String(utf8String: str_url.cString(using: .utf8)!)!
        checkNickname(urlString: urlString, isComp: false)

    }
    
    
    func checkNickname(urlString : String, isComp : Bool) {
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "get"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authroization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            //print(response)
            
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
                            //print(str)
                            print("text = \(self.tf_name.text)")
                            print("count = \(self.tf_name.text?.utf8.count)")
                            self.label_able.isHidden = false
                            
                            let content = self.tf_name.text!
                            let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
                            let size = content.lengthOfBytes(using: String.Encoding(rawValue: encodingEUCKR))
                            var buffer: [CChar] = [CChar](repeating: 0, count: size)
                            print("buffer count = \(buffer.count)")
                            //if (self.tf_name.text?.utf8.count)! > 12 {
                            if buffer.count > 12 {
                                self.label_able.textColor = UIColor(rgb: 0xFF0000)
                                self.label_able.text = "사용 불가능 합니다."
                            } else {
                                self.label_able.textColor = UIColor(rgb: 0x3129FF)
                                self.label_able.text = "사용 가능 합니다."
                                
                                if isComp {
                                    
                                    self.postRequest("http://106.10.39.154:9999/api/user/change/nickname/", bodyString:"nickname=\(self.tf_name.text!)")
                                }
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
                    
                    userDictionary = newValue
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
                            self.button_tickets.setTitle("\(newValue["ticket"]!)", for: .normal)
                            self.label_inviteCode.text = "\(newValue["invite_code"]!)"
                            if self.userDict["image"] != nil {
                                if let imageUrl = URL(string: "\(self.userDict["image"]!)") {
                                    
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
    
    func postRequestImage(_ urlString: String, bodyString: String, json: [String: Data]){
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data;boundary=*****", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue("multipart/form-data", forHTTPHeaderField: "ENCTYPE")
        request.setValue("certiimage.jpeg", forHTTPHeaderField: "uploaded_file")
        
        /*if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) {
         //var jsonString = String(data: data, encoding: .utf8) {
         //jsonString = jsonString.replacingOccurrences(of: "'", with: "")
         //jsonString = jsonString.replacingOccurrences(of: " ", with: "")
         //jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
         //let data = jsonString.data(using: .utf8, allowLossyConversion: false)
         request.httpBody = data as Data
         }*/
        
        var body = Data()
        guard let imageData = self.image_profile.image!.jpegData(compressionQuality: 0.1) else {
            print("oops")
            return
        }
        
        let lineEnd = "\r\n"
        let twoHyphens = "--"
        let boundary = "*****"
        
        // file data //
        //body.append(("\"uploaded_file\":\"").data(using: .utf8)!)
        //body.append(imageData as Data)
        //body.append(("\"").data(using: .utf8)!)
        
        body.append((twoHyphens + boundary + lineEnd).data(using: .utf8)!)
        body.append(("Content-Disposition: form-data; name=\"uploaded_file\";filename=\"certiimage.jpeg\"" + lineEnd).data(using: .utf8)!)
        body.append((lineEnd).data(using: .utf8)!)
        body.append(imageData as Data)
        body.append((lineEnd).data(using: .utf8)!)
        body.append((twoHyphens + boundary + lineEnd).data(using: .utf8)!)
        
        request.httpBody = body
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            
            DispatchQueue.main.async {
                // 동작 실행
                //self.navigationController?.popToRootViewController(animated: false)
                //self.dismiss(animated: true, completion: nil)
                //self.performSegue(withIdentifier: "segue_main", sender: self)
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
        isStudent = userDictionary["is_student"] as! Int
        
        if userDictionary["user_certified"] as? Int == 0 {
            self.performSegue(withIdentifier: "segue_certi", sender: self)
        }
    }
    
    
    @IBAction func notiBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_notification", sender: self)
    }
    
    @IBAction func ticketBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segue_tickets", sender: self)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let template = KMTFeedTemplate.init { (feedTemplateBuilder) in
            
            feedTemplateBuilder.content = KMTContentObject.init(builderBlock: { (contentBuilder) in
                contentBuilder.title = "야미구 - 야! 미팅 하나만 구해줘"
                contentBuilder.desc = "초대코드: \(self.label_inviteCode.text!)를 입력하고 친구와 함께 야미구에서 미팅을..."
                contentBuilder.imageURL = URL.init(string: "http://106.10.39.154:9999/media/yamigu_kakao_share2.png")!
                contentBuilder.link = KMTLinkObject.init(builderBlock: {(linkBuilder) in
                    linkBuilder.mobileWebURL = URL.init(string: "https://yamigu.party")!
                })
            })
            
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "야미구 시작하기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    
                    linkBuilder.iosExecutionParams = "https://itunes.apple.com/app/id1485834674"
                    //linkBuilder.androidExecutionParams = url
                    
                })
                
            }))

        }
        
        KLKTalkLinkCenter.shared().sendDefault(with: template, success: {(warningMsg, argumentMsg) in
            print("warning message: \(warningMsg)")
        }, failure: {(error) in
            print("error \(error)")
        })
    }
    @IBAction func talkBtnPressed(_ sender: Any) {
        KPFPlusFriend(id: "_xjxamkT").chat()
    }
    
    func updateAlarmCountButton() {
        if self.button_notification != nil {
            self.button_notification.setTitle(" \(alarmCount)", for: .normal)
        }
        
    }
}
