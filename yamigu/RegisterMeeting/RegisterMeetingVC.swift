//
//  RegisterMeetingVC.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class RegisterMeetingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button_place: UIButton!
    @IBOutlet weak var button_date: UIButton!
    @IBOutlet weak var button_people: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var button_request: UIButton!
    @IBOutlet weak var label_caution: UILabel!
    @IBOutlet weak var textView: UITextView!
    var isPeople = true
    
    var isDate = false
    var isPlace = false
    
    var selectedType = 0
    var selectedPlace = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.textView.delegate = self
        
        textView.text = "키, 학력, 나이, 친구들 스타일 등 모든 것을 자랑하세요!"
        textView.textColor = UIColor.lightGray
        
        
        textView.layer.cornerRadius = 4.0
        textView.clipsToBounds = false
        textView.layer.shadowOpacity = 0.4
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        //self.dismiss(animated: false, completion: nil)
        
    }
    
    
    @IBAction func peopleBtnPressed(_ sender: Any) {
        isPeople = true
        isDate = false
        isPlace = false
        
        self.textView.isHidden = true
        self.label_caution.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        
        
        self.tableView.reloadData()
    }
    
    func dateBtnHandler() {
        isPeople = false
        isDate = true
        isPlace = false
        
        self.textView.isHidden = true
        self.label_caution.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        
        if button_date.titleLabel?.text != "날짜" {
            //self.button_place.sendActions(for: .allEvents)
            placeBtnHandler()
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func dateBtnPressed(_ sender: Any) {
        isPeople = false
        isDate = true
        isPlace = false
        
        self.textView.isHidden = true
        self.label_caution.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        /*
        if button_date.titleLabel?.text != "날짜" {
            self.button_place.sendActions(for: .allEvents)
        }*/
 
        self.tableView.reloadData()
    }
    
    func placeBtnHandler() {
        isPeople = false
        isDate = false
        isPlace = true
        
        self.textView.isHidden = true
        self.label_caution.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        
        if button_place.titleLabel?.text != "장소" {
            self.textView.isHidden = false
            self.label_caution.isHidden = false
            self.button_request.isHidden = false
            self.tableView.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func placeBtnPressed(_ sender: Any) {
        isPeople = false
        isDate = false
        isPlace = true
        
        self.textView.isHidden = true
        self.label_caution.isHidden = true
        self.button_request.isHidden = true
        self.tableView.isHidden = false
        
        
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func requestBtnPressed(_ sender: Any) {
        //- meeting_type: 미팅 타입
        //- date: 날짜
        //- place_type: 장소
        //- appeal: 어필 문구
        self.postRequest("http://147.47.208.44:9999/api/meetings/create/")
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func postRequest(_ urlString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        //let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        //request.httpBody = body
        
        var requestDict = Dictionary<String, String>()
        requestDict["meeting_type"] = "\((self.selectedType + 1))"
        requestDict["date"] = button_date.titleLabel?.text!
        requestDict["place"] = "\(self.selectedPlace + 1)"
        requestDict["appeal"] = self.textView.text!
        //let data : Data = NSKeyedArchiver.archivedData(withRootObject: requestDict)
        //JSONSerialization.isValidJSONObject(requestDict)
        //request.httpBody = data
        
        if let data = try? JSONSerialization.data(withJSONObject: requestDict, options: .prettyPrinted),
            let jsonString = String(data: data, encoding: .utf8) {
            request.httpBody = jsonString.data(using: .utf8)
        }
        
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
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        //authKey = newValue["key"]!
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
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
            return 6
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        //cell?.backgroundColor =
        cell?.contentView.backgroundColor = UIColor(rgb: 0xFF7B22)
        let label = cell!.viewWithTag(1) as! UILabel
        label.textColor = UIColor.white
        
        if isPeople {
            self.button_people.setTitle(label.text, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //self.button_date.sendActions(for: .allEvents)
                self.dateBtnHandler()
            }
            
            self.selectedType = indexPath.row
        }
        
        if isDate {
            self.button_date.setTitle(label.text, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //self.button_place.sendActions(for: .allEvents)
                self.placeBtnHandler()
            }
        }
        
        if isPlace {
            self.button_place.setTitle(label.text, for: .normal)
            self.selectedPlace = indexPath.row
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.textView.isHidden = false
                self.label_caution.isHidden = false
                self.button_request.isHidden = false
                self.tableView.isHidden = true
                
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath)
        let label = cell!.viewWithTag(1) as! UILabel
        label.textColor = UIColor.black
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let label = cell.viewWithTag(1) as! UILabel
        label.textColor = UIColor.black
        if isPeople {
            if indexPath.row == 0 {
                label.text = "2:2 소개팅"
            } else if indexPath.row == 1 {
                label.text = "3:3 미팅"
            } else if indexPath.row == 2 {
                label.text = "4:4 미팅"
            }
            
            if label.text == self.button_people.titleLabel?.text {
                cell.setSelected(true, animated: false)
            }
        }
        
        if isDate {
            var date = Date()
            
            var dateComponents = DateComponents()
            
            
            if indexPath.row == 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
            } else if indexPath.row == 1 {
                dateComponents.setValue(1, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 2 {
                dateComponents.setValue(2, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 3 {
                dateComponents.setValue(3, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 4 {
                dateComponents.setValue(4, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 5 {
                dateComponents.setValue(5, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
                
            } else if indexPath.row == 6 {
                dateComponents.setValue(6, for: .day);
                date = Calendar.current.date(byAdding: dateComponents, to: date)!
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                let result = formatter.string(from: date)
                label.text = result
                
            }
            
            if label.text == self.button_date.titleLabel?.text {
                cell.setSelected(true, animated: false)
            }
        }
        
        if isPlace {
            if indexPath.row == 0 {
                label.text = "신촌/홍대"
            } else if indexPath.row == 1 {
                label.text = "건대/왕십리"
            } else if indexPath.row == 2 {
                label.text = "강남"
            } else if indexPath.row == 3 {
                label.text = "수원역"
            } else if indexPath.row == 4 {
                label.text = "인천 송도"
            } else if indexPath.row == 5 {
                label.text = "부산 서면"
            }
            
            if label.text == self.button_place.titleLabel?.text {
                cell.setSelected(true, animated: false)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isPeople {
            height.constant = 198
            return 62
        }
        
        if isDate {
            height.constant = 317
            return 45.3
        }
        
        if isPlace {
            height.constant = 300
            return 50
        }
        
        return 0.0
    }
}
