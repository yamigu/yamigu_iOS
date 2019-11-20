//
//  RegisterVC_2.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoCommon
import KakaoOpenSDK
import Toast_Swift

class RegisterVC_2: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField_nickName: UITextField!
    @IBOutlet weak var button_collage: UIButton!
    @IBOutlet weak var button_office: UIButton!
    @IBOutlet weak var button_certi: UIButton!
    
    @IBOutlet weak var label_check: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var isCollage = false
    var isOffice = false
    
    var isAvailableNickName = false
    
    var userDict = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        textField_nickName.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        self.topConstraint.constant = -200
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        self.topConstraint.constant = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func collageBtnPrssed(_ sender: Any) {
        isCollage = true
        isOffice = false
        if isCollage {
            self.button_collage.layer.borderColor = UIColor(rgb: 0xFFC850).cgColor
            self.button_collage.setTitleColor(UIColor.white, for: .normal)
            self.button_collage.backgroundColor = UIColor(rgb: 0xFFC850)
            
            self.button_office.layer.borderColor = UIColor(rgb: 0xC6C6C6).cgColor
            self.button_office.setTitleColor(UIColor(rgb: 0xC6C6C6), for: .normal)
            self.button_office.backgroundColor = UIColor.white
            
        }
        
        self.check()
        
    }
    @IBAction func officeBtnPrssed(_ sender: Any) {
        isCollage = false
        isOffice = true
        if !isCollage {
            self.button_collage.layer.borderColor = UIColor(rgb: 0xC6C6C6).cgColor
            self.button_collage.setTitleColor(UIColor(rgb: 0xC6C6C6), for: .normal)
            self.button_collage.backgroundColor = UIColor.white
            
            self.button_office.layer.borderColor = UIColor(rgb: 0xFFC850).cgColor
            self.button_office.setTitleColor(UIColor.white, for: .normal)
            self.button_office.backgroundColor = UIColor(rgb: 0xFFC850)
        }
        
        self.check()
    }
    
    @IBAction func certiBtnPrssed(_ sender: Any) {
        checkNickname(urlString: "http://106.10.39.154:9999/api/user/validation/nickname/\(self.textField_nickName.text!)")
        
        if check() {
        
            print("\(self.textField_nickName.text!)")
            self.userDict["nickname"] = self.textField_nickName.text!
            //self.userDict["real_name"] = "김신욱"
            //self.userDict["gender"] = 1
            //self.userDict["phone"] = "010-2512-8143"
            self.userDict["is_student"] = isCollage
            //self.userDict["age"] = 20
            
            performSegue(withIdentifier: "segue_register3", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_register3" {
            let desVC:RegisterVC_3 = segue.destination as! RegisterVC_3
            desVC.userDict = self.userDict
            desVC.isStudent = isCollage
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let urlString = "http://106.10.39.154:9999/api/user/validation/nickname/\(self.textField_nickName.text!)"
        let str_url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        checkNickname(urlString: str_url)
        
        
        return true
    }
    
    func check() -> Bool {
        let index1 = IndexPath(row: 1, section: 0)
        let index2 = IndexPath(row: 2, section: 0)
        
        let cell1 = self.tableView.cellForRow(at: index1)
        let cell2 = self.tableView.cellForRow(at: index2)
        
        if( cell1!.isSelected && cell2!.isSelected && self.textField_nickName.text != "" ) {
            if( isCollage || isOffice ) {
                if isAvailableNickName {
                    self.button_certi.backgroundColor = UIColor(rgb: 0xFF7B22)
                    return true
                }
            } else {
                self.view.makeToast("소속을 선택해주세요!")
            }
        } else {
            self.view.makeToast("약관에 동의해주세요!")
        }
        self.button_certi.backgroundColor = UIColor(rgb: 0xC6C6C6)
        return false
    }
    
    func checkNickname(urlString : String) {
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
                    print(str)
                    
                    DispatchQueue.main.async {
                        print(str)
                        if str.contains("true") {
                            self.isAvailableNickName = true
                            self.label_check.text = "사용 가능합니다."
                            self.label_check.textColor = UIColor.blue
                            //self.check()
                        } else {
                            self.isAvailableNickName = false
                            self.label_check.text = "사용 불가능합니다."
                            self.label_check.textColor = UIColor.red
                            //self.check()
                        }
                    }
                }
            }else{
                print("data nil")
            }
        })
        task.resume()
    }
    
    
}

extension RegisterVC_2:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cell = self.tableView.cellForRow(at: indexPath)
            if cell?.isSelected == true {
                let index1 = IndexPath(row: 1, section: 0)
                let index2 = IndexPath(row: 2, section: 0)
                
                let cell1 = self.tableView.cellForRow(at: index1)
                let cell2 = self.tableView.cellForRow(at: index2)
                
                cell1?.setSelected(true, animated: false)
                cell2?.setSelected(true, animated: false)
                
                //self.tableView.reloadData()
            } else {
                let index1 = IndexPath(row: 1, section: 0)
                let index2 = IndexPath(row: 2, section: 0)
                
                let cell1 = self.tableView.cellForRow(at: index1)
                let cell2 = self.tableView.cellForRow(at: index2)
                
                cell1?.setSelected(false, animated: false)
                cell2?.setSelected(false, animated: false)
                
                //self.tableView.reloadData()
            }
            
            check()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cell = self.tableView.cellForRow(at: indexPath)
            if cell?.isSelected == true {
                let index1 = IndexPath(row: 1, section: 0)
                let index2 = IndexPath(row: 2, section: 0)
                
                let cell1 = self.tableView.cellForRow(at: index1)
                let cell2 = self.tableView.cellForRow(at: index2)
                
                cell1?.setSelected(true, animated: false)
                cell2?.setSelected(true, animated: false)
                
                //self.tableView.reloadData()
            }
            check()
        }
    }
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "AgreementTableViewCell", bundle: nil), forCellReuseIdentifier: "agreementTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agreementTableViewCell") as! AgreementTableViewCell
        let images = ["text_agreement1", "text_agreement2", "text_agreement3"]
        
        cell.image_text.image = UIImage(named: images[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.66
    }
    
}
