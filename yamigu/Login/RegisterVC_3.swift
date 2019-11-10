//
//  RegisterVC_3.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class RegisterVC_3: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var text_departmetn: UITextField!
    @IBOutlet weak var text_belong: UITextField!
    var userDict = Dictionary<String, Any>()

    @IBOutlet weak var button_go: UIButton!
    @IBOutlet weak var button_certi: UIButton!
    @IBOutlet weak var imageVIew_certi: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nextCertiBtnPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.userDict["belong"] = self.text_belong.text
            self.userDict["department"] = self.text_departmetn.text
            
            //self.postRequest("http://147.47.208.44:9999/api/auth/signup", bodyString: "nickname=\(String(describing: userDict["nickname"]))&real_name=\(String(describing: userDict["real_name"]))&gender=\(String(describing: userDict["gender"]))&phone=\(String(describing: userDict["phone"]))&is_student=\(String(describing: userDict["is_student"]))&belong=\(String(describing: userDict["belong"]))&department=\(String(describing: userDict["department"]))&age=\(String(describing: userDict["age"]))")
            //self.postRequest("http://147.47.208.44:9999/api/auth/signup/", bodyString: "nickname=\(String(describing: userDict["nickname"]))&real_name=\(String(describing: userDict["real_name"]))&gender=\(String(describing: userDict["gender"]))&phone=\(String(describing: userDict["phone"]))&is_student=\(String(describing: userDict["is_student"]))&belong=\(String(describing: userDict["belong"]))&department=\(String(describing: userDict["department"]))&age=\(String(describing: userDict["age"]))")
            
            let bodyString = "nickname=\(String(describing: self.userDict["nickname"]))&real_name=\(String(describing: self.userDict["real_name"]))&gender=\(String(describing: self.userDict["gender"]))&phone=\(String(describing: self.userDict["phone"]))&is_student=\(String(describing: self.userDict["is_student"]))&belong=\(String(describing: self.userDict["belong"]))&department=\(String(describing: self.userDict["department"]))&age=\(String(describing: self.userDict["age"]))"
            
            var json = Dictionary<String, Any>()
            json["nickname"] = self.userDict["nickname"] as! String
            json["real_name"] = self.userDict["real_name"] as! String
            json["gender"] = self.userDict["gender"] as! Int
            json["phone"] = self.userDict["phone"] as! String
            json["is_student"] = self.userDict["is_student"] as! Bool
            json["belong"] = self.userDict["belong"] as! String
            json["department"] = self.userDict["department"] as! String
            json["age"] = self.userDict["age"] as! Int
            self.postRequest2("http://147.47.208.44:9999/api/auth/signup/", bodyString: bodyString, json: json)
            
            // self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @IBAction func certiBtnPressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imageVIew_certi.image = image
        } else {
            // error
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBtnPressed(_ sender: Any) {
        userDict["belong"] = self.text_belong.text
        userDict["department"] = self.text_departmetn.text
        
        //self.postRequest("http://147.47.208.44:9999/api/auth/signup", bodyString: "nickname=\(String(describing: userDict["nickname"]))&real_name=\(String(describing: userDict["real_name"]))&gender=\(String(describing: userDict["gender"]))&phone=\(String(describing: userDict["phone"]))&is_student=\(String(describing: userDict["is_student"]))&belong=\(String(describing: userDict["belong"]))&department=\(String(describing: userDict["department"]))&age=\(String(describing: userDict["age"]))")
        //self.postRequest("http://147.47.208.44:9999/api/auth/signup/", bodyString: "nickname=\(String(describing: userDict["nickname"]))&real_name=\(String(describing: userDict["real_name"]))&gender=\(String(describing: userDict["gender"]))&phone=\(String(describing: userDict["phone"]))&is_student=\(String(describing: userDict["is_student"]))&belong=\(String(describing: userDict["belong"]))&department=\(String(describing: userDict["department"]))&age=\(String(describing: userDict["age"]))")
        
        let bodyString = "nickname=\(String(describing: userDict["nickname"]))&real_name=\(String(describing: userDict["real_name"]))&gender=\(String(describing: userDict["gender"]))&phone=\(String(describing: userDict["phone"]))&is_student=\(String(describing: userDict["is_student"]))&belong=\(String(describing: userDict["belong"]))&department=\(String(describing: userDict["department"]))&age=\(String(describing: userDict["age"]))"
        
        var json = Dictionary<String, Any>()
        json["nickname"] = userDict["nickname"] as! String
        json["real_name"] = userDict["real_name"] as! String
        json["gender"] = userDict["gender"] as! Int
        json["phone"] = userDict["phone"] as! String
        json["is_student"] = userDict["is_student"] as! Bool
        json["belong"] = userDict["belong"] as! String
        json["department"] = userDict["department"] as! String
        json["age"] = userDict["age"] as! Int
        
        self.postRequest2("http://147.47.208.44:9999/api/auth/signup/", bodyString: bodyString, json: json)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func postRequest2(_ urlString: String, bodyString: String, json: [String: Any]){
         
          guard let url = URL(string: urlString) else {return}
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
    
          
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
              
            DispatchQueue.main.async {
                // 동작 실행
                self.navigationController?.popToRootViewController(animated: false)
                //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
                //self.performSegue(withIdentifier: "segue_main", sender: self)
            }
          }.resume()
      }
    
    func postRequest(_ urlString: String, bodyString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //[serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        //let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        //request.httpBody = body
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: self.userDict)
        JSONSerialization.isValidJSONObject(self.userDict)
        request.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    print("newValue = \(newValue)")
                    
                    
                } catch {
                    print(error)
                    //self.performSegue(withIdentifier: "segue_main", sender: self)
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                    
                    // 회원가입 이력이 없는경우
                    //self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
        }.resume()
    }
}
