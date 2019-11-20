//
//  RegisterMeetingVC.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class RegisterMeetingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var button_editMeeting: UIButton!
    @IBOutlet weak var button_deleteCard: UIButton!
    
    var meetingDict : Dictionary<String, Any>!
    
    var isEdit = false
    var isRequest = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button_placeUnderline: UIView!
    @IBOutlet weak var button_dateUnderline: UIView!
    @IBOutlet weak var button_peopleUnderline: UIView!
    
    @IBOutlet weak var button_place: UIButton!
    @IBOutlet weak var button_date: UIButton!
    @IBOutlet weak var button_people: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    @IBOutlet weak var constraint_labelBottom: NSLayoutConstraint!
    @IBOutlet weak var label_textCount: UILabel!
    @IBOutlet weak var button_request: UIButton!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var myMeetings = [Dictionary<String, Any>]()
    var dateStrings = [String]()
    
    var isPeople = true
    
    var isDate = false
    var isPlace = false
    
    var selectedType = 0
    var selectedPlace = 0
    
    var textColorOn = UIColor(rgb: 0xFF7B22)
    var textColorOff = UIColor(rgb: 0x707070)
    var buttonSelected = UIImage(named: "icon_arrow_bottom_on")
    var buttonDeselected = UIImage(named: "icon_arrow_bottom")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.textView.delegate = self
        
        self.label_textCount.isHidden = true
        
        textView.text = "키, 학력, 나이, 친구들 스타일 등 모든 것을 자랑하세요!"
        textView.textColor = UIColor.lightGray
        textView.addDoneButton(title: "Done", target: self, selector: #selector(keyboardHide))
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        textView.layer.cornerRadius = 4.0
        textView.clipsToBounds = false
        textView.layer.shadowOpacity = 0.4
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        tableView.clipsToBounds = false
        tableView.layer.shadowOpacity = 0.4
        tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        
        handleButtonImage()
        
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.constraint_labelBottom.constant = -keyboardHeight + 170
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.constraint_labelBottom.constant =  -13
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardHide() {
        self.view.endEditing(false)
        self.constraint_labelBottom.constant =  -13
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "키, 학력, 나이, 친구들 스타일 등 모든 것을 자랑하세요!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        label_textCount.text = "\(self.textView.text.count)/100"
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        button_editMeeting.isHidden = true
        button_deleteCard.isHidden = true
        
        self.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if isEdit {
            let mainTC = self.presentingViewController as! MainTC
            let homeController = mainTC.viewControllers![0] as! HomeVC
            
            DispatchQueue.main.async {
                homeController.myMeetings.removeAll()
                homeController.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.dismiss(animated: false, completion: nil)
        
        if isEdit {
            if isRequest {
                button_editMeeting.isHidden = true
                button_deleteCard.isHidden = true
                
                button_request.isHidden = false
                
                isPeople = true
                isDate = true
                isPlace = true
                
                self.textView.isHidden = false
                
                var type = ""
                let tmpType = "\(self.meetingDict["meeting_type"]!)"
                if tmpType == "1" {
                    type = "2:2 미팅"
                } else if tmpType == "2" {
                    type = "3:3 미팅"
                } else if tmpType == "3" {
                    type = "4:4 미팅"
                }
                let place = self.meetingDict["place_type_name"] as! String
                
                let dateString = self.meetingDict["date"] as! String
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from:dateString)
                
                dateFormatter.dateFormat = "M월"
                let monthString = dateFormatter.string(from: date!)
                
                dateFormatter.dateFormat = "d일"
                let dayString = dateFormatter.string(from: date!)
                
                button_people.setTitle(type, for: .normal)
                button_place.setTitle(place, for: .normal)
                button_date.setTitle(monthString + " "  + dayString, for: .normal)
                
                self.label_title.text = "자신과 친구들을 표현해 주세요!"
                
            } else {
                button_editMeeting.isHidden = false
                button_deleteCard.isHidden = false
                
                isPeople = false
                isDate = false
                isPlace = false
                self.textView.isHidden = false
                
                var type = ""
                let tmpType = "\(self.meetingDict["meeting_type"]!)"
                if tmpType == "1" {
                    type = "2:2 미팅"
                } else if tmpType == "2" {
                    type = "3:3 미팅"
                } else if tmpType == "3" {
                    type = "4:4 미팅"
                }
                let place = self.meetingDict["place_type_name"] as! String
                
                let dateString = self.meetingDict["date"] as! String
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from:dateString)
                
                dateFormatter.dateFormat = "M월"
                let monthString = dateFormatter.string(from: date!)
                
                dateFormatter.dateFormat = "d일"
                let dayString = dateFormatter.string(from: date!)
                
                button_people.setTitle(type, for: .normal)
                button_place.setTitle(place, for: .normal)
                button_date.setTitle(monthString + " " + dayString, for: .normal)
                
                textView.text = self.meetingDict["appeal"] as! String
                
                self.label_title.text = "자신과 친구들을 표현해 주세요!"
                
                self.navigationItem.title = "미팅 수정"
            }
            
            
            handleButtonImage()
        }
    }
    
    @IBAction func editMeetingBtnPressed(_ sender: Any) {
        let id = "\(self.meetingDict["id"]!)"
        var dict : [String: Any] = ["meeting_id" : id]
        
        
        //dict["meeting_type"] = Int("\((self.selectedType + 1))")
        if self.button_place.titleLabel?.text == "신촌/홍대" {
            dict["place"] = 1
        } else if self.button_place.titleLabel?.text == "건대/왕십리" {
            dict["place"] = 2
        } else if self.button_place.titleLabel?.text == "강님" {
            dict["place"] = 3
        }
        
        if self.button_people.titleLabel?.text == "2:2 미팅" {
            dict["meeting_type"] = 1
        } else if self.button_people.titleLabel?.text == "3:3 미팅" {
            dict["meeting_type"] = 2
        } else if self.button_people.titleLabel?.text == "4:4 미팅" {
            dict["meeting_type"] = 3
        }
        
        dict["date"] = (button_date.titleLabel?.text!)!
        //dict["place"] = Int("\(self.selectedPlace + 1)")
        dict["appeal"] = self.textView.text!
        dict["meeting_id"] = "\(self.meetingDict["id"]!)"
        
        
        self.postRequest2("http://106.10.39.154:9999/api/meetings/edit/", bodyString: "\"meeting_id\"=\"\(id)\"&meeting_type=\(self.selectedType + 1)&date=\((button_date.titleLabel?.text!)!)&place=\(self.selectedPlace + 1)&appeal=\(self.textView.text!)", json: dict)
        
        /*DispatchQueue.main.async {
         self.dismiss(animated: true, completion: nil)
         }*/
    }
    
    @IBAction func deleteCardBtnPressed(_ sender: Any) {
        let id = "\(self.meetingDict["id"]!)"
        let dict : [String: Any] = ["meeting_id" : id]
        print(dict)
        
        self.postRequest2("http://106.10.39.154:9999/api/meetings/delete/", bodyString: "\"meeting_id\"=\"\(id)\"", json: dict)
        
        /*DispatchQueue.main.async {
         self.dismiss(animated: true, completion: nil)
         }*/
    }
    
    func postRequest2(_ urlString: String, bodyString: String, json: [String: Any]){
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //request.httpBody = jsonData
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        //let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        //request.httpBody = body
        //let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        //request.httpBody = body
        //let data : Data = NSKeyedArchiver.archivedData(withRootObject: requestDict)
        //JSONSerialization.isValidJSONObject(requestDict)
        //request.httpBody = data
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
            let jsonString = String(data: data, encoding: .utf8) {
            request.httpBody = jsonString.data(using: .utf8)
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
                
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                /*do{
                 let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                 print(json)
                 
                 guard let newValue = json as? Int else {
                 print("invalid format")
                 return
                 
                 }
                 
                 DispatchQueue.main.async {
                 self.dismiss(animated: true, completion: nil)
                 }
                 } catch {
                 print(error)
                 }*/
            }
        }.resume()
    }
    
    func getMyMeeting(urlString : String) {
        
        self.myMeetings.removeAll()
        
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
                    
                    guard let newValue = json as? Array<Dictionary<String, Any>> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.myMeetings.removeAll()
                        self.dateStrings.removeAll()
                        for value in newValue {
                            self.myMeetings.append(value)
                            self.dateStrings.append(value["date"] as! String)
                            
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    func handleButtonImage() {
        button_place.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button_place.imageView!.frame.size.width, bottom: 0, right: button_place.imageView!.frame.size.width);
        button_place.imageEdgeInsets = UIEdgeInsets(top: 0, left: button_place.titleLabel!.frame.size.width + 5.0, bottom: 0, right: -button_place.titleLabel!.frame.size.width - 5.0);
        
        button_date.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button_date.imageView!.frame.size.width, bottom: 0, right: button_date.imageView!.frame.size.width);
        button_date.imageEdgeInsets = UIEdgeInsets(top: 0, left: button_date.titleLabel!.frame.size.width + 5.0, bottom: 0, right: -button_date.titleLabel!.frame.size.width - 5.0);
        
        button_people.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button_people.imageView!.frame.size.width, bottom: 0, right: button_people.imageView!.frame.size.width);
        button_people.imageEdgeInsets = UIEdgeInsets(top: 0, left: button_people.titleLabel!.frame.size.width + 5.0, bottom: 0, right: -button_people.titleLabel!.frame.size.width - 5.0);
        
        tableView.clipsToBounds = false
        tableView.layer.shadowOpacity = 0.4
        tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func peopleBtnPressed(_ sender: Any) {
        isPeople = true
        isDate = false
        isPlace = false
        
        self.textView.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        self.label_textCount.isHidden = true
                
        self.label_title.text = "몇명이서 미팅 나가요?"
        
        
        self.tableView.reloadData()
    }
    
    
    
    func dateBtnHandler() {
        isPeople = false
        isDate = true
        isPlace = false
        
        self.textView.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        self.label_textCount.isHidden = true
                
        self.label_title.text = "언제가 좋아요?"
       
        if button_date.titleLabel?.text != "날짜" {
            //self.button_place.sendActions(for: .allEvents)
            placeBtnHandler()
        }
        handleButtonImage()
        self.tableView.reloadData()
    }
    
    @IBAction func dateBtnPressed(_ sender: Any) {
        isPeople = false
        isDate = true
        isPlace = false
        
        self.textView.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        self.label_textCount.isHidden = true
                
        self.label_title.text = "언제가 좋아요?"
       
        /*
         if button_date.titleLabel?.text != "날짜" {
         self.button_place.sendActions(for: .allEvents)
         }*/
        handleButtonImage()
        self.tableView.reloadData()
    }
    
    func placeBtnHandler() {
        isPeople = false
        isDate = false
        isPlace = true
        
        self.textView.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        self.label_textCount.isHidden = true
                
        self.label_title.text = "어디가 좋아요?"
        
        if button_place.titleLabel?.text != "선호 장소" {
            self.textView.isHidden = false
            self.button_request.isHidden = false
            self.tableView.isHidden = true
            self.label_textCount.isHidden = false
                        
            self.label_title.text = "자신과 친구들을 표현해 주세요!"
            //self.label_bottom_description.text = "타 지역은 추후 업데이트 예정"
        }
        handleButtonImage()
        self.tableView.reloadData()
    }
    
    @IBAction func placeBtnPressed(_ sender: Any) {
        isPeople = false
        isDate = false
        isPlace = true
        
        self.textView.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        self.label_textCount.isHidden = true
                
        self.label_title.text = "어디가 좋아요?"
        
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.constraint_labelBottom.constant = -13
        self.view.layoutIfNeeded()
    }
    @IBAction func requestBtnPressed(_ sender: Any) {
        
        if textView.text == "키, 학력, 나이, 친구들 스타일 등 모든 것을 자랑하세요!" {
            self.view.makeToast("자신과 친구들을 표현해주세요!")
        } else {
            if !isRequest {
                //- meeting_type: 미팅 타입
                //- date: 날짜
                //- place_type: 장소
                //- appeal: 어필 문구
                
                
                self.postRequest("http://106.10.39.154:9999/api/meetings/create/", bodyString: "meeting_type=\(self.selectedType + 1)&date=\((button_date.titleLabel?.text!)!)&place=\(self.selectedPlace + 1)&appeal=\(self.textView.text!)")
            } else {
                //- meeting_type: 미팅 타입
                //- date: 날짜
                //- place: 장소
                //- appeal: 어필 문구
                //- receiver: 신청 대상 미팅
                
                self.postRequest("http://106.10.39.154:9999/api/matching/send_request_new/", bodyString: "meeting_type=\(self.selectedType + 1)&date=\((button_date.titleLabel?.text!)!)&place=\(self.selectedPlace + 1)&appeal=\(self.textView.text!)&meeting_id=\(self.meetingDict["id"]!)")
            }
        }
        
        
        
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func postRequest(_ urlString: String, bodyString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        var requestDict = Dictionary<String, Any>()
        requestDict["meeting_type"] = "\((self.selectedType + 1))"
        requestDict["date"] = (button_date.titleLabel?.text!)!
        requestDict["place"] = "\(self.selectedPlace + 1)"
        requestDict["appeal"] = self.textView.text!
        //let data : Data = NSKeyedArchiver.archivedData(withRootObject: requestDict)
        //JSONSerialization.isValidJSONObject(requestDict)
        //request.httpBody = data
        
        if isRequest {
            requestDict["meeting_id"] = "\(self.meetingDict["id"]!)"
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: requestDict, options: .fragmentsAllowed),
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
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    print(json)
                    
                    guard let newValue = json as? Int else {
                        print("invalid format")
                        return
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        //authKey = newValue["key"]!
                        if newValue >= 0 {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension RegisterMeetingVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPeople {
            return 3
        }
        
        if isDate {
            return 7
        }
        
        if isPlace {
            return 3
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        //cell?.backgroundColor =
        //cell?.contentView.backgroundColor = UIColor(rgb: 0xFF7B22)
        let gradient = CAGradientLayer()
        gradient.frame = cell!.contentView.frame
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        //gradient.opacity = 0.0
        cell!.layer.opacity = 0.0
        gradient.colors = [
            //UIColor(rgb: 0xFFA022).cgColor, // Top0xFF6C2B
            //UIColor(rgb: 0xFF6C2B).cgColor // Bottom
            
            UIColor(red: 255.0 / 255.0, green: 160.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0).cgColor,
            UIColor(red: 255.0 / 255.0, green: 108.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0).cgColor
        ]
        gradient.locations = [0, 0.5, 1]
        cell!.layer.insertSublayer(gradient, at: 1)
        
        UIView.animate(withDuration: Double(0.3), animations: { () -> Void in
            
            cell!.layer.opacity = 1.0
            
            }, completion: { (_) -> Void in
                gradient.removeFromSuperlayer()
        })
        
        
        let label = cell!.viewWithTag(1) as! UILabel
        label.textColor = UIColor.white
        
        if isPeople {
            self.button_people.setTitle(label.text, for: .normal)
            self.button_people.setTitleColor(self.textColorOn, for: .normal)
            self.button_people.setImage(self.buttonSelected, for: .normal)
            self.button_peopleUnderline.backgroundColor = self.textColorOn
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //self.button_date.sendActions(for: .allEvents)
                self.dateBtnHandler()
            }
            
            self.selectedType = indexPath.row
        }
        
        if isDate {
            let dateString = label.text!
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "M/d EE"
            formatter.locale = Locale(identifier: "ko_kr")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            let resultDate = formatter.date(from: dateString)
            
            formatter.dateFormat = "M월 d일"
            let result = formatter.string(from: resultDate!)
            label.text = result
            
            
            self.button_date.setTitle(result, for: .normal)
            self.button_date.setTitleColor(self.textColorOn, for: .normal)
            self.button_date.setImage(self.buttonSelected, for: .normal)
            self.button_dateUnderline.backgroundColor = self.textColorOn
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //self.button_place.sendActions(for: .allEvents)
                if self.button_people.titleLabel?.text == "인원" {
                    self.peopleBtnPressed(self.button_people)
                } else {
                    self.placeBtnHandler()
                }
                
            }
        }
        
        if isPlace {
            self.button_place.setTitle(label.text, for: .normal)
            self.button_place.setTitleColor(self.textColorOn, for: .normal)
            self.button_place.setImage(self.buttonSelected, for: .normal)
            self.button_placeUnderline.backgroundColor = self.textColorOn
            
            self.selectedPlace = indexPath.row
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if self.button_people.titleLabel?.text == "인원" {
                    self.peopleBtnPressed(self.button_people)
                } else if self.button_date.titleLabel?.text == "날짜" {
                    self.dateBtnPressed(self.button_date)
                } else {
                    self.textView.isHidden = false
                    self.button_request.isHidden = false
                    self.tableView.isHidden = true
                    self.label_textCount.isHidden = false
                                        
                    self.label_title.text = "자신과 친구들을 표현해 주세요!"
                }
                
                
            }
            
            
        }
        handleButtonImage()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath)
        let label = cell!.viewWithTag(1) as! UILabel
        label.textColor = UIColor.black
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.contentView.backgroundColor = UIColor.clear
        
//        if indexPath.row % 2 == 0 {
//            cell.contentView.backgroundColor = UIColor(rgb: 0xFCFCFC)
//        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        cell.isSelected = false
        let label = cell.viewWithTag(1) as! UILabel
        label.textColor = UIColor.black
        if isPeople {
            if indexPath.row == 0 {
                label.text = "2:2 미팅"
            } else if indexPath.row == 1 {
                label.text = "3:3 미팅"
            } else if indexPath.row == 2 {
                label.text = "4:4 미팅"
            }
            
            if label.text == self.button_people.titleLabel?.text {
                cell.setSelected(true, animated: false)
            }
            
            cell.isUserInteractionEnabled = true
        }
        
        if isDate {
            
            cell.isUserInteractionEnabled = true
            var date = Date()
            
            var dateComponents = DateComponents()
            
            
            if indexPath.row == 0 {
                let formatter = DateFormatter()
                
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
            } else if indexPath.row == 1 {
                dateComponents.setValue(1, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 2 {
                dateComponents.setValue(2, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 3 {
                dateComponents.setValue(3, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 4 {
                dateComponents.setValue(4, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 5 {
                dateComponents.setValue(5, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 6 {
                dateComponents.setValue(6, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d EE"
                formatter.locale = Locale(identifier: "ko_kr")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                let result = formatter.string(from: date)
                label.text = result
                
            }
            
            if label.text?.last == "토" {
                label.textColor = UIColor.blue
            }
            else if label.text?.last == "일" {
                label.textColor = UIColor.red
            }
            
            if label.text == self.button_date.titleLabel?.text {
                cell.setSelected(true, animated: false)
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            
            print("dateString = \(dateString)")
            
            if self.dateStrings.contains(dateString) {
                label.textColor = UIColor.lightGray
                cell.isUserInteractionEnabled = false
            }
            
        }
        
        if isPlace {
            if indexPath.row == 0 {
                label.text = "신촌/홍대"
            } else if indexPath.row == 1 {
                label.text = "건대/왕십리"
            } else if indexPath.row == 2 {
                label.text = "강남"
            }
            
            if label.text == self.button_place.titleLabel?.text {
                cell.setSelected(true, animated: false)
            }
            cell.isUserInteractionEnabled = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isPeople {
            height.constant = 186
            return 62
        }
        
        if isDate {
            height.constant = 317
            return 45.3
        }
        
        if isPlace {
            height.constant = 150
            return 50
        }
        
        return 0.0
    }
}
