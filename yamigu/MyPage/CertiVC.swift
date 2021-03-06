//
//  CertiVC.swift
//  yamigu
//
//  Created by ph7164 on 13/11/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class CertiVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label_belong: UILabel!
    @IBOutlet weak var tf_belong: UITextField!
    
    @IBOutlet weak var label_department: UILabel!
    @IBOutlet weak var tf_department: UITextField!
    
    @IBOutlet weak var label_certificate: UILabel!
    @IBOutlet weak var imageView_certi: UIImageView!
    @IBOutlet weak var button_certi: UIButton!
    @IBOutlet weak var label_certiDetail: UILabel!
    @IBOutlet weak var imageView_description: UIImageView!
    
    @IBOutlet weak var button_certiBelong: UIButton!
    
    var userDict = Dictionary<String, Any>()
    var isStudent : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {

        self.view.endEditing(true)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.scrollView.endEditing(true)
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
    
    @IBAction func certiBelongBtnPressed(_ sender: Any) {
        
        self.userDict["belong"] = self.tf_belong.text
        self.userDict["department"] = self.tf_department.text
        
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
        
        self.postRequest2("http://13.124.126.30:9999/api/auth/signup/", bodyString: bodyString, json: json)
        
//        let imageData = imageView_certi.image!.jpegData(compressionQuality: 1)
//
//
        var jsonImg = Dictionary<String, Data>()
        //jsonImg["uploaded_file"] = self.imageView_certi.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        jsonImg.updateValue(self.imageView_certi.image!.jpegData(compressionQuality: 0.1)!, forKey: "uploaded_file")

        self.postRequestImage("http://13.124.126.30:9999/api/user/certificate/", bodyString: "uploaded_file=", json: jsonImg)
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
                //self.navigationController?.popToRootViewController(animated: false)
                self.dismiss(animated: true, completion: nil)
                //self.performSegue(withIdentifier: "segue_main", sender: self)
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
        guard let imageData = self.imageView_certi.image!.jpegData(compressionQuality: 0.1) else {
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
                self.dismiss(animated: true, completion: nil)
                //self.performSegue(withIdentifier: "segue_main", sender: self)
            }
        }.resume()
    }

}

extension CertiVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupUI() {
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if isStudent == 0 {
            self.label_belong.text = "회사 입력"
            self.tf_belong.placeholder = "ex) 삼성전자, 스타트업, 프리랜서, 개인병원, 고등학교"
            self.label_department.text = "직업 입력"
            self.tf_department.placeholder = "ex) 직장인, 디자이너, 치과의사, 선생님"
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imageView_certi.image = image
        } else {
            // error
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
