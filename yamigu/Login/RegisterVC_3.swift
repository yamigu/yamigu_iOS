//
//  RegisterVC_3.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class RegisterVC_3: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label_belong: UILabel!
    @IBOutlet weak var label_department: UILabel!
    @IBOutlet weak var label_certificate: UILabel!
    @IBOutlet weak var label_certiDetail: UILabel!
    
    
    @IBOutlet weak var text_departmetn: UITextField!
    @IBOutlet weak var text_belong: UITextField!
    var userDict = Dictionary<String, Any>()
    
    @IBOutlet weak var button_go: UIButton!
    @IBOutlet weak var button_certi: UIButton!
    @IBOutlet weak var imageVIew_certi: UIImageView!
    
    @IBOutlet weak var imageView_description: UIImageView!
    
    var isStudent = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.text_departmetn.delegate = self
        self.text_belong.delegate = self
        
        if !isStudent {
            self.label_belong.text = "회사 입력"
            self.text_belong.placeholder = "ex) 삼성전자, 스타트업, 프리랜서, 개인병원, 고등학교"
            self.label_department.text = "직업 입력"
            self.text_departmetn.placeholder = "ex) 직장인, 디자이너, 치과의사, 선생님"
            self.label_certificate.text = "직장 인증"
            self.label_certiDetail.text = "사원증, 명함, 사업자등록증, 자격증, 면허증 등 첨부해주세요 !"
            self.imageView_description.image = UIImage(named: "descriptIon_register2")
        }
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isStudent {
            self.label_belong.text = "회사 입력"
            self.text_belong.placeholder = "ex) 삼성전자, 스타트업, 프리랜서, 개인병원, 고등학교"
            self.label_department.text = "직업 입력"
            self.text_departmetn.placeholder = "ex) 직장인, 디자이너, 치과의사, 선생님"
            self.label_certificate.text = "직장 인증"
            self.label_certiDetail.text = "사원증, 명함, 사업자등록증, 자격증, 면허증 등 첨부해주세요 !"
            self.imageView_description.image = UIImage(named: "descriptIon_register2")
        }
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {

        self.view.endEditing(true)

    }
    
    @IBAction func nextCertiBtnPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.userDict["belong"] = self.text_belong.text
            self.userDict["department"] = self.text_departmetn.text
                        
            let bodyString = "nickname=\(String(describing: self.userDict["nickname"]))&real_name=\(String(describing: self.userDict["real_name"]))&gender=\(String(describing: self.userDict["gender"]))&phone=\(String(describing: self.userDict["phone"]))&is_student=\(String(describing: self.userDict["is_student"]))&belong=\(String(describing: self.userDict["belong"]))&department=\(String(describing: self.userDict["department"]))&age=\(String(describing: self.userDict["age"]))"
            
            var json = Dictionary<String, Any>()
            json["nickname"] = self.userDict["nickname"] as! String
            json["real_name"] = self.userDict["real_name"] as! String
            json["gender"] = self.userDict["gender"] as! Int
            json["phone"] = self.userDict["phone"] as! String
            if self.userDict["is_student"] as! Bool {
                json["is_student"] = "true"
            } else {
                json["is_student"] = "false"
            }
            json["belong"] = self.userDict["belong"] as! String
            json["department"] = self.userDict["department"] as! String
            json["age"] = self.userDict["age"] as! Int
            self.postRequest2("http://13.124.126.30:9999/api/auth/signup/", bodyString: bodyString, json: json)
            
        }
    }
    
    @IBAction func certiBtnPressed(_ sender: Any) {
        
        let certiAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        certiAlert.addAction(UIAlertAction(title: "사진찍기", style: .default, handler: { (action: UIAlertAction!) in
            
            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = UIImagePickerController.SourceType.camera
            image.allowsEditing = false
            
            self.present(image, animated: true)
            
        }))

        certiAlert.addAction(UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {
            (action: UIAlertAction!) in
            
            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            
            self.present(image, animated: true) {
                
            }
            
        }))
        
        certiAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(certiAlert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imageVIew_certi.image = image
            self.check()
        } else {
            // error
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func check() -> Bool {
        
        if self.text_belong.text != "" && self.text_departmetn.text != "" && imageVIew_certi?.image != nil {
            self.button_go.backgroundColor = UIColor(rgb: 0xFF7B22)
            self.button_go.isEnabled = true
            
            return true
        }
        
        self.button_go.isEnabled = false
        self.button_go.backgroundColor = UIColor(rgb: 0xC6C6C6)
        return false
    }
    
    @IBAction func goBtnPressed(_ sender: Any) {
        
        if check() {
            userDict["belong"] = self.text_belong.text
            userDict["department"] = self.text_departmetn.text
            let bodyString = "nickname=\(String(describing: userDict["nickname"]))&real_name=\(String(describing: userDict["real_name"]))&gender=\(String(describing: userDict["gender"]))&phone=\(String(describing: userDict["phone"]))&is_student=\(String(describing: userDict["is_student"]))&belong=\(String(describing: userDict["belong"]))&department=\(String(describing: userDict["department"]))&age=\(String(describing: userDict["age"]))&cert_img=\(String(describing: userDict["cert_img"]))"
            
            var json = Dictionary<String, Any>()
            json["nickname"] = userDict["nickname"] as! String
            json["real_name"] = userDict["real_name"] as! String
            json["gender"] = userDict["gender"] as! Int
            json["phone"] = userDict["phone"] as! String
            if self.userDict["is_student"] as! Bool {
                json["is_student"] = "true"
            } else {
                json["is_student"] = "false"
            }
            json["belong"] = userDict["belong"] as! String
            json["department"] = userDict["department"] as! String
            json["age"] = userDict["age"] as! Int
            
            if let friendCode = userDict["friend_code"] as? String {
                json["friend_code"] = friendCode
            }
            
            self.postRequest2("http://13.124.126.30:9999/api/auth/signup/", bodyString: bodyString, json: json)
            
            var jsonImg = Dictionary<String, Data>()
            jsonImg.updateValue(self.imageVIew_certi.image!.jpegData(compressionQuality: 0.1)!, forKey: "uploaded_file")
            
            self.postRequestImage("http://13.124.126.30:9999/api/user/certificate/", bodyString: "uploaded_file=", json: jsonImg)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.scrollView.endEditing(true)
        self.check()
    }
    
    func postRequest2(_ urlString: String, bodyString: String, json: [String: Any]){
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
            var jsonString = String(data: data, encoding: .utf8) {
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
                goToLoginCheckVC()
                self.navigationController?.isNavigationBarHidden = true

            }
        }.resume()
    }
    
    func postRequestImage(_ urlString: String, bodyString: String, json: [String: Data]){
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data;boundary=*****", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue("multipart/form-data", forHTTPHeaderField: "ENCTYPE")
        request.setValue("certiimage.jpeg", forHTTPHeaderField: "uploaded_file")
        
        var body = Data()
        guard let imageData = self.imageVIew_certi.image!.jpegData(compressionQuality: 0.1) else {
            print("oops")
            return
        }
        
        let lineEnd = "\r\n"
        let twoHyphens = "--"
        let boundary = "*****"
        
        
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
            }
        }.resume()
    }
}

extension RegisterVC_3: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.check()
    }
    
}
