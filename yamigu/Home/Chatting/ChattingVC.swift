//
//  ChattingVC.swift
//  yamigu
//
//  Created by Yoon on 26/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChattingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var button_send: UIButton!
    
    @IBOutlet weak var button_call: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tf_message: UITextField!
    @IBOutlet weak var constraint_bottom: NSLayoutConstraint!
    
    var meetingDict = Dictionary<String, Any>()
    var matchDict = Dictionary<String, Any>()
    var matchingId = ""
    var messages = Array<Dictionary<String, Any>>()
    var managerData = Dictionary<String, Any>()
    
    let cellId = "cellId"
    let cellLeftId = "cellLeftId"
    
    var ref: DatabaseReference!
    var refHandle : DatabaseHandle!
    
    var chatRef: DatabaseReference!
    var chatRefHandle : DatabaseHandle!
    
    var myMessageCount = 0
    var partnerMessageCount = 0
    
    func checkId() {
        
        
        var received = Dictionary<String, Any>()
        var sent = Dictionary<String, Any>()
        
        received = meetingDict["received_request"] as! Dictionary<String, Any>
        sent = meetingDict["sent_request"] as! Dictionary<String, Any>
        
        var received_request = Array<Dictionary<String, Any>>()
        var sent_request = Array<Dictionary<String, Any>>()
        
        received_request = received["data"] as! Array<Dictionary<String, Any>>
        sent_request = sent["data"] as! Array<Dictionary<String, Any>>
        
        for dict in received_request {
            if (dict["is_selected"] as! Bool) {
                matchingId = "\(dict["id"]!)"
                managerData = dict
            }
        }
        
        for dict in sent_request {
            if (dict["is_selected"] as! Bool) {
                matchingId = "\(dict["id"]!)"
                managerData = dict
            }
        }
        
        print(meetingDict)
        print(managerData)
        print(matchDict)
        
        let dateString = meetingDict["date"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "d일"
        let resultDateString = dateFormatter.string(from: date!)
        
        let placeString = meetingDict["place_type_name"] as! String
        
        let type = "\(meetingDict["meeting_type"]!)"
        var typeString = ""
        if type == "1" {
            typeString = "2:2"
        } else if type == "2" {
            typeString = "3:3"
        } else {
            typeString = "4:4"
        }
        
        self.navigationController?.title = resultDateString + " || " + placeString + " || " + typeString
        self.title = resultDateString + " || " + placeString + " || " + typeString
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatRef.removeObserver(withHandle: chatRefHandle)
        ref.removeObserver(withHandle: refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Bundle.main.loadNibNamed("ChattingHeaderVIew", owner: self, options: nil)
        collectionView.register(UINib(nibName: "ChattingHeaderVIew", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView?.register(ChattingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ChattingLeftCell.self, forCellWithReuseIdentifier: cellLeftId)
        collectionView.register(ChattingImageCell.self, forCellWithReuseIdentifier: "shopCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        matchDict = meetingDict["matched_meeting"] as! Dictionary<String, Any>
        matchingId = "\(matchDict["id"]!)"
        
        ref = Database.database().reference()
        chatRef = Database.database().reference()
        
        checkId()
        
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismissal))
        gesture.delegate = self
        self.collectionView.addGestureRecognizer(gesture)
        
        self.checkMessages()
    }
    
    @objc func keyboardDismissal() {
        self.view.endEditing(true)
        constraint_bottom.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
            let lastItemIndex = NSIndexPath(item: item, section: 0)
            
            constraint_bottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
            
            self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .bottom, animated: false)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        constraint_bottom.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMessages()
    }
    
    func getMessages() {
        refHandle = ref.child("message").child(matchingId).observe(DataEventType.childAdded, with: { (snapshot) in
            print(snapshot.value)
            if let snapshot_messages = snapshot.value as? Dictionary<String,Any> {
                //for mg in snapshot_messages {
                //self.messages.append(mg)
                //}
                
                self.messages.append(snapshot_messages)
                
                if (snapshot_messages["idSender"] as! String) == (userDictionary["uid"] as! String) {
                    self.myMessageCount += 1
                } else {
                    self.partnerMessageCount += 1
                }
                
                self.collectionView.reloadData()
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = NSIndexPath(item: item, section: 0)
                self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .bottom, animated: false)
            }
            
            
        })
        
    }
    
    func checkMessages(){
        
        chatRef = Database.database().reference().child("user").child(userDictionary["uid"] as! String).child("receivedMessages").child(self.matchingId)
        chatRefHandle = chatRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                let isUnread = dictionary["isUnread"] as! Bool
                if !isUnread {
                    let dict = ["isUnread":true]
                    self.chatRef.child(snapshot.key).updateChildValues(dict)
                }
            }
        })
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let message = self.messages[indexPath.row]
        
        if (message["message"] as! String) == "###manager-place-content###" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! ChattingImageCell
            
            let dateString =  "\(message["time"]!)"
            let dateDoube = Double(dateString)! / 1000.0
            print("datedouble = \(dateDoube)")
            let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
            
            let dateFomatter = DateFormatter(format: "a KK:mm")
            dateFomatter.locale = Locale(identifier: "ko_kr")
            dateFomatter.timeZone = TimeZone(abbreviation: "KST")
            cell.timeLabel.text = dateFomatter.string(from: date).replacingOccurrences(of: "00", with: "12")
            
            cell.profileImageView.downloaded(from: "\(self.managerData["manager_profile"]!)")
            
            return cell
        }
        
        if (message["idSender"] as! String) == (userDictionary["uid"] as! String) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChattingCell
            print("userDictionary = \(userDictionary)")
            
            let gender = userDictionary["gender"] as! Int
            if gender == 1 {
                cell.bubbleView.backgroundColor = UIColor(rgb: 0xE7E6FF)
                cell.nameLabel.textColor = UIColor(rgb: 0x298CFF)
            } else {
                cell.bubbleView.backgroundColor = UIColor(rgb: 0xFFE6F8)
                cell.nameLabel.textColor = UIColor(rgb: 0xFE528E)
            }
            
            cell.textView.text = message["message"] as! String
            let dateString =  "\(message["time"]!)"
            let dateDoube = Double(dateString)! / 1000.0
            print("datedouble = \(dateDoube)")
            let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
            
            let dateFomatter = DateFormatter(format: "a KK:mm")
            dateFomatter.locale = Locale(identifier: "ko_kr")
            dateFomatter.timeZone = TimeZone(abbreviation: "KST")
            cell.timeLabel.text = dateFomatter.string(from: date).replacingOccurrences(of: "00", with: "12")
            
            cell.nameLabel.text = message["userName"] as! String
            
            cell.profileImageView.downloaded(from: userDictionary["image"] as! String)
            
            
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(message["message"] as! String).width + 32
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLeftId, for: indexPath) as! ChattingLeftCell
            
            let gender = userDictionary["gender"] as! Int
            if gender == 1 {
                cell.bubbleView.backgroundColor = UIColor(rgb: 0xFFE6F8)
                cell.nameLabel.textColor = UIColor(rgb: 0xFE528E)
            } else {
                cell.bubbleView.backgroundColor = UIColor(rgb: 0xE7E6FF)
                cell.nameLabel.textColor = UIColor(rgb: 0x298CFF)
            }
            
            cell.textView.text = message["message"] as! String
            let dateString =  "\(message["time"]!)"
            let dateDoube = Double(dateString)! / 1000.0
            print("datedouble = \(dateDoube)")
            let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
            
            let dateFomatter = DateFormatter(format: "a KK:mm")
            dateFomatter.locale = Locale(identifier: "ko_kr")
            dateFomatter.timeZone = TimeZone(abbreviation: "KST")
            cell.timeLabel.text = dateFomatter.string(from: date).replacingOccurrences(of: "00", with: "12")
            
            cell.nameLabel.text = message["userName"] as! String
            
            //cell.profileImageView.downloaded(from: userDictionary["image"] as! String)
            
            
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(message["message"] as! String).width + 32
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        let message = self.messages[indexPath.row]
        //get estimated height somehow????
        let text = message["message"] as! String
        height = estimateFrameForText(text).height + 50
        var width = estimateFrameForText(text).width
        
        
        if text == "###manager-place-content###"  {
            return CGSize(width: view.frame.width, height: 194.0)
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 413.0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! ChattingHeaderVIew
        
        let profileImageView = header.viewWithTag(21) as! UIImageView
        let profileImageVIew2 = header.viewWithTag(22) as! UIImageView
        let label_name = header.viewWithTag(2) as! UILabel
        let label_name2 = header.viewWithTag(3) as! UILabel
        let label_time = header.viewWithTag(4) as! UILabel
        let label_time2 = header.viewWithTag(5) as! UILabel
        let label_openbyName = header.viewWithTag(10) as! UILabel
        let label_openbyDepartment = header.viewWithTag(11) as! UILabel
        let label_partnerName = header.viewWithTag(12) as! UILabel
        let label_partnerDepartment = header.viewWithTag(13) as! UILabel
        let label_date = header.viewWithTag(14) as! UILabel
        let label_place = header.viewWithTag(15) as! UILabel
        let label_type = header.viewWithTag(16) as! UILabel
        
        
        
        profileImageView.downloaded(from: "\(self.managerData["manager_profile"]!)")
        profileImageVIew2.downloaded(from: "\(self.managerData["manager_profile"]!)")
        
        label_name.text = "야미구 매니저 \(self.managerData["manager_name"]!)"
        label_name2.text = "야미구 매니저 \(self.managerData["manager_name"]!)"
        
        let DateString = "\(self.managerData["accepted_at"]!)"
        let dateDouble = Double(DateString)!  / 1000.0
        let date = Date(timeIntervalSince1970: dateDouble as! TimeInterval)
        let dateFomatter = DateFormatter(format: "a KK:mm")
        dateFomatter.locale = Locale(identifier: "ko_kr")
        dateFomatter.timeZone = TimeZone(abbreviation: "KST")
        label_time.text = dateFomatter.string(from: date).replacingOccurrences(of: "00", with: "12")
        label_time2.text = dateFomatter.string(from: date).replacingOccurrences(of: "00", with: "12")
        label_openbyName.text = "\(self.meetingDict["openby_nickname"]!)" + "(\(self.meetingDict["openby_age"]!))"
        label_openbyDepartment.text = "\(self.meetingDict["openby_department"]!) \(self.meetingDict["openby_belong"]!)"
        
        var matchedDict = Dictionary<String, Any>()
        matchedDict = self.meetingDict["matched_meeting"] as! Dictionary<String, Any>
        
        label_partnerName.text = "\(matchedDict["openby_nickname"]!)" + "(\(matchedDict["openby_age"]!))"
        label_partnerDepartment.text = "\(matchedDict["openby_belong"]!) \(matchedDict["openby_department"]!)"
        
        //label_date.text = "\(self.meetingDict["date"]!)"
        let dateString2 = "\(self.meetingDict["date"]!)"
        var dateFomatter2 = DateFormatter(format: "yyyy-MM-dd")
        let date2 = dateFomatter2.date(from: dateString2)
        dateFomatter2.dateFormat = "M월 d일"
        label_date.text = dateFomatter2.string(from: date2!)
        
        
        label_place.text = "\(self.meetingDict["place_type_name"]!)"
        
        let type = self.meetingDict["meeting_type"] as! Int
        if type == 1 {
            label_type.text = "2:2 미팅"
        } else if type == 2{
            label_type.text = "3:3 미팅"
        } else {
            label_type.text = "4:4 미팅"
        }
        
        
        let gender = userDictionary["gender"] as! Int
        if gender == 1 {
            label_openbyName.textColor = UIColor(rgb: 0x298CFF)
            label_partnerName.textColor = UIColor(rgb: 0xFF538F)
        } else {
            label_openbyName.textColor = UIColor(rgb: 0xFF538F)
            label_partnerName.textColor = UIColor(rgb: 0x298CFF)
        }
        
        return header
    }
    
    @IBAction func quitBtnPressed(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "", message: "매칭을 취소하시겠어요?\n취소하기전에 상대방에게 사유를 전달해주세요\n단, 매칭 취소시 티켓은 반환되지 않습니다", preferredStyle: UIAlertController.Style.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "아니요", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "네,취소할게요", style: .default, handler: { (action: UIAlertAction!) in
            var json = Dictionary<String, Any>()
            json["match_id"] = self.matchingId
            
            self.postRequest2("http://106.10.39.154:9999/api/matching/cancel_matching/", bodyString: "", json: json)
        }))
        
        present(logoutAlert, animated: true, completion: nil)
        
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        if self.tf_message.text! != "" {
            var newRef = self.ref.child("message").child(matchingId).childByAutoId()
            let key = newRef.key
            
            var messageDict = Dictionary<String, Any>()
            messageDict["id"] = key
            messageDict["idSender"] = userDictionary["uid"]!
            messageDict["message"] = self.tf_message.text!
            messageDict["userName"] = userDictionary["nickname"]!
            messageDict["time"] = Date().currentTimeMillis()
            
            newRef.updateChildValues(messageDict)
            
            if partnerMessageCount > 0 && myMessageCount == 0 {
                let newRef2 = self.ref.child("message").child(matchingId).childByAutoId()
                let key2 = newRef2.key
                
                var messageDict2 = Dictionary<String, Any>()
                messageDict2["id"] = key
                messageDict2["idSender"] = managerData["manager_uid"]!
                messageDict2["message"] = "###manager-place-content###"
                messageDict2["userName"] = managerData["manager_name"]!
                messageDict2["time"] = Date().currentTimeMillis()
                
                newRef2.updateChildValues(messageDict2)
            }
            
            var dict = Dictionary<String, Any>()
            dict["id"] = key
            dict["isUnread"] = false
            self.ref.child("user").child(self.matchDict["openby_uid"]! as! String).child("receivedMessages").child(matchingId).child(key!).updateChildValues(dict)
            
            dict["isUnread"] = true
            
            self.ref.child("user").child(userDictionary["uid"]! as! String).child("receivedMessages").child(matchingId).child(key!).updateChildValues(dict)
            
            
            
            
            var json = [String:Any]()
            
            //json["receiverId"] = matchDict["openby_uid"]!
            json["receiverId"] = matchDict["openby_uid"]!
            //json["message"] = self.tf_message.text!
            //json["activity"] = "ChattingActivity"
            
            var intent_args = [String:Any]()
            intent_args["partner_age"] = meetingDict["openby_age"]!
            intent_args["partner_belong"] = meetingDict["openby_belong"]!
            intent_args["partner_department"] = meetingDict["openby_department"]!
            intent_args["partner_nickname"] = meetingDict["openby_nickname"]!
            intent_args["partner_uid"] = meetingDict["id"]!
            
            intent_args["date"] = meetingDict["date"]!
            intent_args["place"] = meetingDict["place_type_name"]!
            intent_args["type"] = meetingDict["meeting_type"]!
            intent_args["meeting_id"] = meetingDict["id"]!
            intent_args["matching_id"] = matchingId
            intent_args["manage_name"] = managerData["manager_name"]!
            //intent_args["partner_uid"] = matchDict["openby_uid"]!
            intent_args["manager_uid"] = managerData["manager_uid"]!
            intent_args["accepted_at"] = managerData["accepted_at"]!
            
            var data = [String:Any]()
            
            data["title"] = meetingDict["openby_nickname"]!
            data["content"] = self.tf_message.text!
            data["clickAction"] = ".ChattingActivity"
            data["intentArgs"] = intent_args
            
            json["data"] = data
            
            
            self.postRequest("http://106.10.39.154:9999/api/fcm/send_push/", bodyString: "", json: json)
            
            self.tf_message.text = ""
        }
    }
    @IBAction func callBtnPressed(_ sender: Any) {
        //icon_chatting_alarm
        //self.button_call.tintColor = UIColor(rgb: 0xFF7B22)
        self.view.makeToast("매니저를 호출하였습니다.")
        self.button_call.setImage(UIImage(named: "icon_chatting_alarm_on"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            //self.button_call.tintColor = UIColor(rgb: 0x707070)
            self.button_call.setImage(UIImage(named: "icon_chatting_alarm"), for: .normal)
        }
        
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        //self.view.endEditing(true)
    }
}

// migration & model

extension ChattingVC {
    
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        //return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.init(name: "NanumGothic", size: 14.0)]), context: nil)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 14.0)]), context: nil)
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
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
            let jsonString = String(data: data, encoding: .utf8) {
            print("jsonString = \(jsonString.data(using: .utf8))")
            request.httpBody = jsonString.data(using: .utf8)!
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func postRequest(_ urlString: String, bodyString: String, json: [String: Any]){
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //request.httpBody = jsonData
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed),
            let jsonString = String(data: data, encoding: .utf8) {
            print("jsonString = \(jsonString.data(using: .utf8))")
            request.httpBody = jsonString.data(using: .utf8)!
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
