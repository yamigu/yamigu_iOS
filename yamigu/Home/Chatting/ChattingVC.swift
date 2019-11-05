//
//  ChattingVC.swift
//  yamigu
//
//  Created by Yoon on 26/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChattingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
   
    func checkId() {
        print(meetingDict)
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ChattingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ChattingLeftCell.self, forCellWithReuseIdentifier: cellLeftId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        matchDict = meetingDict["matched_meeting"] as! Dictionary<String, Any>
        matchingId = "\(matchDict["id"]!)"
        
        ref = Database.database().reference()
        
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
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            constraint_bottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
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
                
                self.collectionView.reloadData()
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = NSIndexPath(item: item, section: 0)
                self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .bottom, animated: false)
            }
            
            
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let message = self.messages[indexPath.row]
        
        if (message["idSender"] as! String) == (userDictionary["uid"] as! String) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLeftId, for: indexPath) as! ChattingLeftCell
            
            
            cell.textView.text = message["message"] as! String
            let dateString =  "\(message["time"]!)"
            let dateDoube = Double(dateString)! / 1000.0
            print("datedouble = \(dateDoube)")
            let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
            
            let dateFomatter = DateFormatter(format: "a H:mm")
            dateFomatter.locale = Locale(identifier: "ko_kr")
            dateFomatter.timeZone = TimeZone(abbreviation: "KST")
            cell.timeLabel.text = dateFomatter.string(from: date)
            
            cell.nameLabel.text = message["userName"] as! String
            
            cell.profileImageView.downloaded(from: userDictionary["image"] as! String)
            
            
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(message["message"] as! String).width + 32
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChattingCell
            
            cell.textView.text = message["message"] as! String
            let dateString =  "\(message["time"]!)"
            let dateDoube = Double(dateString)! / 1000.0
            print("datedouble = \(dateDoube)")
            let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
            
            let dateFomatter = DateFormatter(format: "a H:mm")
            dateFomatter.locale = Locale(identifier: "ko_kr")
            dateFomatter.timeZone = TimeZone(abbreviation: "KST")
            cell.timeLabel.text = dateFomatter.string(from: date)
            
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
        height = estimateFrameForText(text).height + 65
        var width = estimateFrameForText(text).width
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    @IBAction func quitBtnPressed(_ sender: Any) {
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        var newRef = self.ref.child("message").child(matchingId).childByAutoId()
        let key = newRef.key
        
        var messageDict = Dictionary<String, Any>()
        messageDict["id"] = key
        messageDict["idSender"] = userDictionary["uid"]!
        messageDict["message"] = self.tf_message.text!
        messageDict["userName"] = userDictionary["nickname"]!
        messageDict["time"] = Date().currentTimeMillis()
        
        newRef.updateChildValues(messageDict)
        
        var dict = Dictionary<String, Any>()
        dict["id"] = key
        dict["isUnread"] = false
        self.ref.child("user").child(userDictionary["uid"]! as! String).child("receivedMessages").child(matchingId).child(key!).updateChildValues(dict)
        
        dict["isUnread"] = true
        self.ref.child("user").child(self.matchDict["openby_uid"]! as! String).child("receivedMessages").child(matchingId).child(key!).updateChildValues(dict)
        
        
        
        
        var json = [String:Any]()
        
        json["receiverId"] = matchDict["openby_uid"]!
        //json["message"] = self.tf_message.text!
        //json["activity"] = "ChattingActivity"
        
        var intent_args = [String:Any]()
        intent_args["partner_age"] = matchDict["openby_age"]!
        intent_args["partner_belong"] = matchDict["openby_belong"]!
        intent_args["partner_department"] = matchDict["openby_department"]!
        intent_args["partner_nickname"] = matchDict["openby_nickname"]!
        
        intent_args["date"] = meetingDict["date"]!
        intent_args["place"] = meetingDict["place_type_name"]!
        intent_args["meeting_id"] = meetingDict["id"]!
        intent_args["matching_id"] = matchingId
        intent_args["manage_name"] = managerData["manager_name"]!
        intent_args["partner_uid"] = matchDict["openby_uid"]!
        intent_args["manager_uid"] = managerData["manager_uid"]!
        intent_args["accepted_at"] = managerData["accepted_at"]!
        
        var data = [String:Any]()
        
        data["title"] = meetingDict["openby_nickname"]!
        data["content"] = self.tf_message.text!
        data["clickAction"] = ".ChattingActivity"
        data["intentArgs"] = intent_args
        
        json["data"] = data
        
        
        self.postRequest("http://147.47.208.44:9999/api/fcm/send_push/", bodyString: "", json: json)
        
        self.tf_message.text = ""
    }
    @IBAction func callBtnPressed(_ sender: Any) {
        
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
    
    func postRequest(_ urlString: String, bodyString: String, json: [String: Any]){
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //request.httpBody = jsonData
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
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
                    
                    guard let newValue = json as? Dictionary<String, String> else {
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
