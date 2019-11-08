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

class RegisterVC_2: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField_nickName: UITextField!
    @IBOutlet weak var button_collage: UIButton!
    @IBOutlet weak var button_office: UIButton!
    @IBOutlet weak var button_certi: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var isCollage = true
    
    var userDict = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
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
        if isCollage {
            self.button_collage.layer.borderColor = UIColor(rgb: 0xFFC850).cgColor
            self.button_collage.setTitleColor(UIColor(rgb: 0xFFC850), for: .normal)
            
            self.button_office.layer.borderColor = UIColor(rgb: 0xC6C6C6).cgColor
            self.button_office.setTitleColor(UIColor(rgb: 0xC6C6C6), for: .normal)
            
            
        }
        
    }
    @IBAction func officeBtnPrssed(_ sender: Any) {
        isCollage = false
        if !isCollage {
            self.button_collage.layer.borderColor = UIColor(rgb: 0xC6C6C6).cgColor
            self.button_collage.setTitleColor(UIColor(rgb: 0xC6C6C6), for: .normal)
            
            self.button_office.layer.borderColor = UIColor(rgb: 0xFFC850).cgColor
            self.button_office.setTitleColor(UIColor(rgb: 0xFFC850), for: .normal)
            
        }
    }
    
    @IBAction func certiBtnPrssed(_ sender: Any) {
        checkNickname(urlString: "http://147.47.208.44:9999/api/user/validation/nickname/\(self.textField_nickName.text!)")
        
        if check() {
        
            print("\(self.textField_nickName.text!)")
            self.userDict["nickname"] = self.textField_nickName.text!
            self.userDict["real_name"] = "김신욱"
            self.userDict["gender"] = 1
            self.userDict["phone"] = "010-2512-8143"
            self.userDict["is_student"] = isCollage
            self.userDict["age"] = 20
            
            performSegue(withIdentifier: "segue_register3", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_register3" {
            let desVC:RegisterVC_3 = segue.destination as! RegisterVC_3
            desVC.userDict = self.userDict
            
        }
    }
    
    func check() -> Bool {
        let index1 = IndexPath(row: 1, section: 0)
        let index2 = IndexPath(row: 2, section: 0)
        
        let cell1 = self.tableView.cellForRow(at: index1)
        let cell2 = self.tableView.cellForRow(at: index2)
        
        if( cell1!.isSelected && cell2!.isSelected && self.textField_nickName.text != "" ) {
            return true
        }
        
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
