//
//  HomeVC.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import FirebaseDatabase

var selectedDate = ""

class HomeVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myMeetingTableView: UITableView!
    @IBOutlet weak var myMeetingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendMeetingCollectionView: UICollectionView!
    
    @IBOutlet weak var todayMeetingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var todayMeetingTableView: UITableView!
    
    @IBOutlet weak var button_addMeeting: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var myMeetings = [Dictionary<String, Any>]()
    var todayMeetings = [Dictionary<String, Any>]()
    
    var matchingMeetingCount = 0
    
    var selectedMyMeeting = Dictionary<String, Any>()
    
    let meetingType = ["2:2 소개팅", "3:3 미팅", "4:4 미팅"]
    let places = ["신촌/홍대", "건대/왕십리", "강남", "수원역", "인천 송도", "부산 서면"]
    
    var reviewDict = Dictionary<String, Any>()
    var ratedLook = ""
    var ratedFun = ""
    var ratedManner = ""
    var reviewText = ""
    
    var ref: DatabaseReference!
    var refHandle : DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupCollectionView()
        
        self.getTodayMeeting(urlString: "http://147.47.208.44:9999/api/meetings/today/")
        self.getMyMeeting(urlString: "http://147.47.208.44:9999/api/meetings/my/")
        
        ref = Database.database().reference()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTodayMeeting(urlString: "http://147.47.208.44:9999/api/meetings/today/")
        self.getMyMeeting(urlString: "http://147.47.208.44:9999/api/meetings/my/")
        
        ref = Database.database().reference()
        
        
    }
    @IBAction func addMeetingBtnPressed(_ sender: Any) {
        let tabView = self.tabBarController as! MainTC
        tabView.pressed(sender: tabView.menuButton)
    }
    
    func getTodayMeeting(urlString : String) {
        guard let url = URL(string: urlString) else {return}
        self.todayMeetings.removeAll()
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
                        for value in newValue {
                            self.todayMeetings.append(value)
                        }
                        
                        self.todayMeetingTableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            
        })
        task.resume()
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
                        self.matchingMeetingCount = 0
                        self.myMeetings.removeAll()
                        for value in newValue {
                            self.myMeetings.append(value)
                            if (value["is_matched"] as! Bool) {
                                self.matchingMeetingCount += 1
                            }
                        }
                        
                        if self.myMeetings.count == 0 {
                            self.button_addMeeting.isHidden = false
                            self.topConstraint.constant = 107
                        } else {
                            self.button_addMeeting.isHidden = true
                            self.topConstraint.constant = 15.5
                        }
                        
                        self.myMeetingTableView.reloadData()
                        let tabbarController = self.tabBarController as! MainTC
                        tabbarController.menuButton.setTitle("\(self.myMeetings.count)/3", for: .normal)
                    }
                } catch {
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
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
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let jsonString = String(data: data, encoding: .utf8) {
            request.httpBody = jsonString.data(using: .utf8)
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                //print(res)
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_matching" {
            let destination = segue.destination as! UINavigationController
            let des = destination.visibleViewController as! MatchVC
            
            des.matchingDict = self.selectedMyMeeting
        }
        
        if segue.identifier == "segue_chatting"{
            let destination = segue.destination as! UINavigationController
            let des = destination.visibleViewController as! ChattingVC
            
            des.meetingDict = self.selectedMyMeeting
        }
        
        if segue.identifier == "segue_editMeeting" {
            let destination = segue.destination as! UINavigationController
            let des = destination.visibleViewController as! RegisterMeetingVC
            
            des.isEdit = true
            des.meetingDict = self.selectedMyMeeting
        }
    }
    
}

extension HomeVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.myMeetingTableView {
            return 1
        } else if tableView == self.todayMeetingTableView {
            
            
            return 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == self.myMeetingTableView {
            if section != 0 {
                return 16.0
            }
            
        } else if tableView == self.todayMeetingTableView {
            if section != 0 {
                return 11.0
            }
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.myMeetingTableView {
            // matching cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeMyTableViewCell") as! HomeMyTableViewCell
            
            
            
            cell.delegate = self
            cell.index = indexPath.section
            let meetingDict = myMeetings[indexPath.section]
            cell.label_type.text = self.meetingType[Int((meetingDict["meeting_type"] as! Int) - 1)]
            cell.label_place.text = meetingDict["place_type_name"] as! String
            
            
            
            if !(meetingDict["is_matched"] as! Bool) {
                cell.view_bottom.isHidden = true
                cell.constraint_bottomHeight.constant = 0.0
                cell.layoutIfNeeded()
                
                cell.button_applyTeam.isHidden = false
                cell.button_watingTeam.isHidden = false
                cell.button_edit.isHidden = false
                
                cell.label_isMatched.isHidden = true
                
                cell.label_matchingDepart.isHidden = true
                cell.label_matchingName.isHidden = true
                
                
                var received = Dictionary<String, Any>()
                received = meetingDict["received_request"] as! Dictionary<String, Any>
                
                var received_request = Array<Dictionary<String, Any>>()
                
                received_request = received["data"] as! Array<Dictionary<String, Any>>
                
                if received_request.count == 0 {
                    //cell.label_teamCount.isHidden = true
                    cell.label_teamCount.isHidden = false
                    cell.label_teamCount.text = "\(received_request.count)팀 신청!"
                } else {
                    cell.label_teamCount.isHidden = false
                    cell.label_teamCount.text = "\(received_request.count)팀 신청!"
                }
                
            } else {
                cell.view_bottom.isHidden = false
                cell.constraint_bottomHeight.constant = 44.0
                cell.layoutIfNeeded()
                
                cell.button_applyTeam.isHidden = true
                cell.button_watingTeam.isHidden = true
                cell.button_edit.isHidden = true
                
                cell.label_isMatched.isHidden = false
                cell.label_teamCount.isHidden = true
                
                cell.label_matchingDepart.isHidden = false
                cell.label_matchingName.isHidden = false
                
                
                var matchingId = ""
                
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
                    }
                }
                
                for dict in sent_request {
                    if (dict["is_selected"] as! Bool) {
                        matchingId = "\(dict["id"]!)"
                    }
                }
                
                self.getMessages(uid: userDictionary["uid"]! as! String, matchId: matchingId) { (count) in
                    print("count = \(count)")
                    if count == 0 {
                        cell.label_chattingCount.isHidden = true
                    } else {
                        cell.label_chattingCount.isHidden = false
                        cell.label_chattingCount.text = "\(count)"
                    }
                }
                
                let matchDict = meetingDict["matched_meeting"] as! Dictionary<String, Any>
                
                let matchAge = matchDict["openby_age"] as! String
                let matchName = matchDict["openby_nickname"] as! String
                let matchBelong = matchDict["openby_belong"] as! String
                let matchDepart = matchDict["openby_department"] as! String
                
                cell.label_matchingName.text = matchName + matchAge
                cell.label_matchingDepart.text = matchBelong + ", " + matchDepart
                ref.child("message/\(matchingId)/").queryLimited(toLast: 1).observe(.value) { (snapshot) in
                    for snap in snapshot.children.allObjects as! [DataSnapshot] {
                            let value = snap.value as? [String: Any] ?? [:] // A good way to unwrap optionals in a single line
                            let time = value["time"]!
                            print("time \(time)")
                            
                            let dateString = "\(time)"
                            let dateDoube = Double(dateString)! / 1000.0
                            print("datedouble = \(dateDoube)")
                            let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
                            
                            let dateFomatter = DateFormatter(format: "a H:mm")
                            dateFomatter.locale = Locale(identifier: "ko_kr")
                            dateFomatter.timeZone = TimeZone(abbreviation: "KST")
                            cell.label_chattingTime.text = dateFomatter.string(from: date)
                            
                            
                            if let message = value["message"] as? String {
                                DispatchQueue.main.async {
                                    //
                                    cell.label_lastChat.text = message
                                }
                                
                                
                            }
                            
                            
                            
                        }
                    }
                }
                /*
                ref.child("message/\(matchingId)/").queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    for snap in snapshot.children.allObjects as! [DataSnapshot] {
                        let value = snap.value as? [String: Any] ?? [:] // A good way to unwrap optionals in a single line
                        let time = value["time"]!
                        print("time \(time)")
                        
                        let dateString = "\(time)"
                        let dateDoube = Double(dateString)! / 1000.0
                        print("datedouble = \(dateDoube)")
                        let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
                        
                        let dateFomatter = DateFormatter(format: "a H:mm")
                        dateFomatter.locale = Locale(identifier: "ko_kr")
                        dateFomatter.timeZone = TimeZone(abbreviation: "KST")
                        cell.label_chattingTime.text = dateFomatter.string(from: date)
                        
                        
                        if let message = value["message"] as? String {
                            DispatchQueue.main.async {
                                //
                                cell.label_lastChat.text = message
                            }
                            
                            
                        }
                        
                        
                        
                    }
                })
                { (error) in
                    print(error.localizedDescription)
                }
            }*/
            
            let dateString = meetingDict["date"] as! String
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:dateString)
            
            dateFormatter.dateFormat = "M월"
            let monthString = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "d일"
            let dayString = dateFormatter.string(from: date!)
            
            cell.label_month.text = monthString
            cell.label_day.text = dayString
            
            if daysBetween(start: Date(), end: date!) == 0 {
                cell.label_dday.text = "today"
            } else {
                cell.label_dday.text = "D-\(daysBetween(start: Date(), end: date!))"
            }
            
            // review cell
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: "homeReviewCell") as! HomeReviewCell
            reviewCell.delegate = self
            
            self.reviewDict = myMeetings[indexPath.section]
            self.ratedLook = "\(reviewCell.ratedLook)"
            self.ratedFun = "\(reviewCell.ratedFun)"
            self.ratedManner = "\(reviewCell.ratedManner)"
            self.reviewText = reviewCell.textview_review.text
            
            return cell
            
        } else if tableView == self.todayMeetingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeExpectedTableViewCell") as! HomeExpectedTableViewCell
            let meetingDict = todayMeetings[indexPath.section]
            cell.contentView.layer.borderColor = UIColor(rgb: 0xE5E5E5).cgColor
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.cornerRadius = 10.0
            
            cell.label_type.text = self.meetingType[Int((meetingDict["meeting_type"] as! Int) - 1)]
            cell.label_place.text = meetingDict["place_type_name"] as! String
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeMyTableViewCell") as! HomeMyTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.myMeetingTableView {
            self.selectedMyMeeting = myMeetings[indexPath.section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let mymeetingCount = self.myMeetings.count
        let todaymeetingCount = self.todayMeetings.count
        
        var height = 167.0 * Double(mymeetingCount) + 16.0 * Double(mymeetingCount - 1) + Double(44 * matchingMeetingCount)
        
        self.myMeetingTableViewHeight.constant = CGFloat(height)
        var height2 = 86.0 * Double(todaymeetingCount) + 11.0 * Double(todaymeetingCount - 1)
        
        self.todayMeetingTableViewHeight.constant = CGFloat(height2)
        
        height = height + height2
        
        DispatchQueue.main.async {
            self.scrollView.layoutIfNeeded()
            self.myMeetingTableView.layoutIfNeeded()
            if self.myMeetings.count == 0 {
                self.scrollView.contentSize.height = CGFloat(226.0 + 316.5 + 50.0 + height + 107.0)
            } else {
                self.scrollView.contentSize.height = CGFloat(226.0 + 316.5 + 50.0 + height)
            }
            
            
        }
        
        if tableView == self.myMeetingTableView {
            
            return mymeetingCount
        } else if tableView == self.todayMeetingTableView {
            return todaymeetingCount
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.myMeetingTableView {
            
            let meetingDict = self.myMeetings[indexPath.section]
            if !(meetingDict["is_matched"] as! Bool) {
                return 167.0
            }
            return 211.0
            
        } else if tableView == self.todayMeetingTableView {
            return 86.0
        }
        
        return 0.0
    }
    
    func setupTableView() {
        self.myMeetingTableView.dataSource = self
        self.myMeetingTableView.delegate = self
        
        self.todayMeetingTableView.delegate = self
        self.todayMeetingTableView.dataSource = self
        
        self.myMeetingTableView.register(UINib(nibName: "HomeMyTableViewCell", bundle: nil), forCellReuseIdentifier: "homeMyTableViewCell")
        self.myMeetingTableView.register(UINib(nibName: "HomeReviewCell", bundle: nil), forCellReuseIdentifier: "homeReviewCell")
        
        self.todayMeetingTableView.register(UINib(nibName: "HomeExpectedTableViewCell", bundle: nil), forCellReuseIdentifier: "homeExpectedTableViewCell")
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.contentView.layer.borderColor = UIColor(rgb: 0xE0E0E0).cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.cornerRadius = 10.0
        
        cell.layer.cornerRadius = 10.0
        
        
        return cell
    }
    
    func setupCollectionView() {
        self.recommendMeetingCollectionView.delegate = self
        self.recommendMeetingCollectionView.dataSource = self
        
        self.recommendMeetingCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 291.0, height: 222.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func getMessages(uid:String, matchId:String, completionHandler:@escaping (Int) -> ()){
        
        let ref = Database.database().reference().child("user").child(uid).child("receivedMessages").child(matchId)
        var count = 0
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                let isUnread = dictionary["isUnread"] as! Bool
                if !isUnread {
                    count += 1
                }
            }
            completionHandler(count)
        })
        
        
    }
}
    
    extension HomeVC : HomeTalbeViewDelegate {
        func chat(index: Int) {
            self.selectedMyMeeting = self.myMeetings[index]
            
            self.performSegue(withIdentifier: "segue_chatting", sender: self)
        }
        
        func viewApplyList(index: Int) {
            self.selectedMyMeeting = self.myMeetings[index]
            
            self.performSegue(withIdentifier: "segue_matching", sender: self)
        }
        
        func viewWatingList(index: Int) {
            self.selectedMyMeeting = self.myMeetings[index]
            let dateString = selectedMyMeeting["date"] as! String
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:dateString)
            
            dateFormatter.dateFormat = "M월"
            let monthString = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "d일"
            let dayString = dateFormatter.string(from: date!)
            
            selectedDate = monthString+" "+dayString
            
            DispatchQueue.main.async {
                let watingNavController = self.tabBarController?.viewControllers![1] as! UINavigationController
                let watingController = watingNavController.topViewController as! WatingVC
                
                watingController.selectedType.removeAll()
                watingController.selectedDate.removeAll()
                watingController.selectedPlace.removeAll()
                
                let type = self.selectedMyMeeting["meeting_type"] as! Int
                let place_type = self.selectedMyMeeting["place_type"] as! Int
                
                let dateString2 = self.selectedMyMeeting["date"] as! String
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date2 = dateFormatter.date(from: dateString2)
                
                watingController.selectedType.append(type)
                watingController.selectedDate.append(date2!)
                watingController.selectedPlace.append(place_type)
                
                watingController.makeBody()
                watingController.updateUI()
                
                self.tabBarController?.selectedIndex = 1
            }
            
            
        }
        
        func edit(index: Int) {
            self.selectedMyMeeting = self.myMeetings[index]
            
            self.performSegue(withIdentifier: "segue_editMeeting", sender: self)
        }
        
    }
    
    extension HomeVC: HomeReviewDelegate {
        func sendReview() {
            let id = "\(self.reviewDict["id"]!)"
            let dict : [String: Any] = ["meeting_id" : id]
            
            self.postRequest2("http://147.47.208.44:9999/api/meetings/feedback/", bodyString: "\"meeting_id\"=\"\(id)\"&feedback=\(self.reviewText)", json: dict)
        }
        
        func sendRatings() {
            let id = "\(self.reviewDict["id"]!)"
            let dict : [String: Any] = ["meeting_id" : id]
            
            self.postRequest2("http://147.47.208.44:9999/api/meetings/rate/", bodyString: "\"meeting_id\"=\"\(id)\"&visual=\(self.ratedLook)&fun=\(self.ratedFun)&manner=\(self.ratedManner)", json: dict)
        }
}



