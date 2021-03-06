//
//  MatchVC.swift
//  yamigu
//
//  Created by Yoon on 21/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class MatchVC: UIViewController, UINavigationBarDelegate {
    @IBOutlet weak var button_receive: UIButton!
    @IBOutlet weak var button_request: UIButton!
    
    @IBOutlet weak var label_totalCount: UILabel!
    @IBOutlet weak var label_count: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button_left: UIButton!
    @IBOutlet weak var button_right: UIButton!
    
    var newPage = 0
    
    var matchingDict : Dictionary<String, Any>!
    
    var receiveMatchingList = [Dictionary<String, Any>]()
    var requestMatchingList = [Dictionary<String, Any>]()
    
    let meetingType = ["2:2 미팅", "3:3 미팅", "4:4 미팅"]
    var blackBackgroundView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        self.button_receive.setTitleColor(UIColor(rgb: 0xFF7B22), for: .selected)
        self.button_request.setTitleColor(UIColor(rgb: 0xFF7B22), for: .selected)
        // Do any additional setup after loading the view.
        
       //self.navigationController?.navigationBar.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let presendtindVC = self.presentingViewController {
            let mainTC = presendtindVC  as! MainTC
            let homeController = mainTC.viewControllers![0] as! HomeVC
            
            DispatchQueue.main.async {
                homeController.myMeetings.removeAll()
                homeController.getMyMeeting(urlString: "http://13.124.126.30:9999/api/meetings/my/")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.button_receive.isSelected = true
        
        self.button_left.setTitle("거절하기", for: .normal)
        self.button_right.setTitle("미팅하기", for: .normal)
        
        let date = self.matchingDict["date"] as! String
        var type = ""
        let tmpType = "\(self.matchingDict["meeting_type"]!)"
        if tmpType == "1" {
            type = "2:2 미팅"
        } else if tmpType == "2" {
            type = "3:3 미팅"
        } else if tmpType == "3" {
            type = "4:4 미팅"
        }
        let place = self.matchingDict["place_type_name"] as! String
        self.title = date + " || " + place + " || " + type
        
        let id = "\(self.matchingDict["id"]!)"
        
        self.getReceiveMatching(urlString: "http://13.124.126.30:9999/api/matching/received_request/?meeting_id=\(id)")
        self.getRequestMatching(urlString: "http://13.124.126.30:9999/api/matching/sent_request/?meeting_id=\(id)")
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "MatchCell", bundle: nil), forCellWithReuseIdentifier: "matchCell")
    }
    
    @IBAction func backBtnPreesed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func receiveBtnPressed(_ sender: Any) {
        self.button_receive.isSelected = true
        self.button_request.isSelected = false
        
        self.button_left.setTitle("거절하기", for: .normal)
        self.button_right.setTitle("미팅하기", for: .normal)
        
        self.button_left.isHidden = false
        self.button_right.isHidden = false
        
        self.newPage = 0
        self.label_count.text = "1"
        if self.receiveMatchingList.count == 0 {
            self.label_count.text = "0"
        }
        self.label_totalCount.text = String(self.receiveMatchingList.count)
        self.collectionView.reloadData()
        
    }
    @IBAction func requestBtnPressed(_ sender: Any) {
        self.button_receive.isSelected = false
        self.button_request.isSelected = true
        
        self.button_left.setTitle("대기중", for: .normal)
        self.button_right.setTitle("취소하기", for: .normal)
        
        self.button_left.isHidden = true
        self.button_right.isHidden = true
        
        self.newPage = 0
        self.label_count.text = "1"
        if self.requestMatchingList.count == 0 {
            self.label_count.text = "0"
        }
        self.label_totalCount.text = String(self.requestMatchingList.count)
        self.collectionView.reloadData()
    }
    @IBAction func leftBtnPressed(_ sender: Any) {
        if button_left.titleLabel?.text! == "거절하기" {
            if self.receiveMatchingList.count != 0 {
                let id = "\(self.receiveMatchingList[newPage]["id"]!)"
                let dict : [String: Any] = ["request_id" : id]
                self.postRequest("http://13.124.126.30:9999/api/matching/decline_request/", bodyString: "\"request_id\"=\"\(id)\"", json: dict)
                
                self.view.makeToast("미팅을 거절했어요!")
                
                self.blackBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
                self.blackBackgroundView.makeToastActivity(.center)
                self.blackBackgroundView.frame = self.view.frame
                self.view.addSubview(blackBackgroundView)
            }
            
            
        } else if button_left.titleLabel?.text! == "취소하기" {
            if self.requestMatchingList.count != 0 {
                let id = "\(self.requestMatchingList[newPage]["id"]!)"
                let dict : [String: Any] = ["request_id" : id]
                
                self.postRequest("http://13.124.126.30:9999/api/matching/cancel_request/", bodyString: "\"meeting_id\"=\"\(id)\"", json: dict)
            }
            
            
        }
    }
    @IBAction func rightBtnPressed(_ sender: Any) {
        if button_right.titleLabel?.text! == "미팅하기" {
            if self.receiveMatchingList.count != 0 {
                let id = "\(self.receiveMatchingList[newPage]["id"]!)"
                let dict : [String: Any] = ["request_id" : id]
                self.postRequest("http://13.124.126.30:9999/api/matching/accept_request/", bodyString: "\"request_id\"=\"\(id)\"", json: dict)
                self.blackBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
                self.blackBackgroundView.makeToastActivity(.center)
                self.blackBackgroundView.frame = self.view.frame
                self.view.addSubview(blackBackgroundView)
            }
            
        } else if button_right.titleLabel?.text! == "대기중" {
        }
        
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
                    if urlString == "http://13.124.126.30:9999/api/matching/decline_request/" {
                        let id = "\(self.matchingDict["id"]!)"
                        self.blackBackgroundView.removeFromSuperview()
                        self.getReceiveMatching(urlString: "http://13.124.126.30:9999/api/matching/received_request/?meeting_id=\(id)")
                        
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                    /*guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    */
                    
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func getRequestMatching(urlString : String) {
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
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    guard let newValue = json as? Array<Dictionary<String, Any>> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        //print(newValue)
                        for value in newValue {
                            self.requestMatchingList.append(value)
                        }
                        
                        
                        self.collectionView.reloadData()
                        
                    }
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func getReceiveMatching(urlString : String) {
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        self.receiveMatchingList.removeAll()
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
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    guard let newValue = json as? Array<Dictionary<String, Any>> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        //print(newValue)
                        for value in newValue {
                            self.receiveMatchingList.append(value)
                            
                        }
                        
                        self.label_totalCount.text = String(self.receiveMatchingList.count)
                        self.newPage = 0
                        self.label_count.text = "1"
                        if self.receiveMatchingList.count == 0 {
                            self.label_count.text = "0"
                        }
                        self.collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func getUserInfo(urlString : String) {
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
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        // 동작 실행
                        //print(newValue)
                        userDictionary = newValue
                        self.performSegue(withIdentifier: "segue_main", sender: self)
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                    self.performSegue(withIdentifier: "segue_onboarding", sender: self)
                }
            }
            
        })
        task.resume()
    }
}

extension MatchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = 0
        
        if self.button_receive.isSelected {
            returnValue = self.receiveMatchingList.count
        } else if self.button_request.isSelected {
            returnValue = self.requestMatchingList.count
        }
        
        return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCell", for: indexPath) as! MatchCell
        
        if self.button_receive.isSelected {
            let dict = receiveMatchingList[indexPath.row]
            let detailsDict = dict["sender"] as! Dictionary<String, Any>
            
            let nickName = detailsDict["openby_nickname"] as! String
            let age = detailsDict["openby_age"] as! String
            let belong = detailsDict["openby_belong"] as! String
            let department = detailsDict["openby_department"] as! String
            
            let dateString = detailsDict["date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.locale = Locale(identifier: "ko_kr")
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:dateString)
            
            dateFormatter.dateFormat = "M월"
            let monthString = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "d일"
            let dayString = dateFormatter.string(from: date!)
            
            if let imageUrl = URL(string: "\(detailsDict["openby_profile"]!)") {
                cell.image_profile.downloaded(from: imageUrl)
                cell.image_profile.contentMode = .scaleAspectFill
            }

            cell.label_meetingType.text = self.meetingType[Int((detailsDict["meeting_type"] as! Int) - 1)]
            cell.textview_details.text = detailsDict["appeal"] as! String
            cell.label_nicknameAndAge.text = "\(nickName)(\(age))"
            cell.label_belongAndDepartment.text = "\(belong),\(department)"
            cell.label_meetingDate.text = monthString+dayString
            cell.label_meetingPlace.text = detailsDict["place_type_name"] as! String
            
            let meeting_type = "\(detailsDict["meeting_type"]!)"
            
            if meeting_type == "1" {
                cell.label_meetingType.text = "2:2 미팅"
                cell.label_meetingType.textColor = color2
                cell.image_bottom.image = UIImage(named: "orange_bar")
                cell.view_textContainer.bordercolor = color2
                
                cell.label_meetingPlace.textColor = color2
                cell.label_meetingDate.textColor = color2
                
                cell.bordercolor = color2
                
                for i in 0...2 {
                    cell.textUnderline[i].backgroundColor = color2
                }

            } else if meeting_type == "2" {
                cell.label_meetingType.text = "3:3 미팅"
                cell.label_meetingType.textColor = color3
                cell.image_bottom.image = UIImage(named: "orange_bar_2")
                cell.view_textContainer.bordercolor = color3
                
                cell.label_meetingPlace.textColor = color3
                cell.label_meetingDate.textColor = color3
                
                cell.bordercolor = color3
                
                for i in 0...2 {
                    cell.textUnderline[i].backgroundColor = color3
                }

            } else if meeting_type == "3" {
                cell.label_meetingType.text = "4:4 미팅"
                cell.label_meetingType.textColor = color4
                cell.image_bottom.image = UIImage(named: "orange_bar_3")
                cell.view_textContainer.bordercolor = color4
                
                cell.label_meetingPlace.textColor = color4
                cell.label_meetingDate.textColor = color4
                
                cell.bordercolor = color4
                
                for i in 0...2 {
                    cell.textUnderline[i].backgroundColor = color4
                }

            }
            
            
            
        }
        else if self.button_request.isSelected {
            
            let dict = requestMatchingList[indexPath.row]
            let detailsDict = dict["receiver"] as! Dictionary<String, Any>
            
            let nickName = detailsDict["openby_nickname"] as! String
            let age = detailsDict["openby_age"] as! String
            let belong = detailsDict["openby_belong"] as! String
            let department = detailsDict["openby_department"] as! String
            
            let dateString = detailsDict["date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.locale = Locale(identifier: "ko_kr")
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:dateString)
            
            dateFormatter.dateFormat = "MM월 dd일 (EE)"

            if let imageUrl = URL(string: "\(detailsDict["openby_profile"]!)") {
                cell.image_profile.downloaded(from: imageUrl)
                cell.image_profile.contentMode = .scaleAspectFill
            }

            cell.label_meetingType.text = self.meetingType[Int((detailsDict["meeting_type"] as! Int) - 1)]
            cell.textview_details.text = detailsDict["appeal"] as! String
            cell.label_nicknameAndAge.text = "\(nickName) (\(age))"
            cell.label_belongAndDepartment.text = "\(belong), \(department)"
            cell.label_meetingDate.text = dateFormatter.string(from: date!)
            cell.label_meetingPlace.text = detailsDict["place_type_name"] as! String
            
            let meeting_type = "\(detailsDict["meeting_type"]!)"
            
            if meeting_type == "1" {
                cell.label_meetingType.text = "2:2 미팅"
                cell.label_meetingType.textColor = color2
                cell.image_bottom.image = UIImage(named: "orange_bar")
                cell.view_textContainer.bordercolor = color2
                
                cell.label_meetingPlace.textColor = color2
                cell.label_meetingDate.textColor = color2
                
                for i in 0...2 {
                    cell.textUnderline[i].backgroundColor = color2
                }

            } else if meeting_type == "2" {
                cell.label_meetingType.text = "3:3 미팅"
                cell.label_meetingType.textColor = color3
                cell.image_bottom.image = UIImage(named: "orange_bar_2")
                cell.view_textContainer.bordercolor = color3
                
                cell.label_meetingPlace.textColor = color3
                cell.label_meetingDate.textColor = color3
                
                for i in 0...2 {
                    cell.textUnderline[i].backgroundColor = color3
                }

            } else if meeting_type == "3" {
                cell.label_meetingType.text = "4:4 미팅"
                cell.label_meetingType.textColor = color4
                cell.image_bottom.image = UIImage(named: "orange_bar_3")
                cell.view_textContainer.bordercolor = color4
                
                cell.label_meetingPlace.textColor = color4
                cell.label_meetingDate.textColor = color4
                
                for i in 0...2 {
                    cell.textUnderline[i].backgroundColor = color4
                }

            }
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = 315.0
        
        if collectionView.frame.size.width <= 320.0 {
            width = Double(collectionView.frame.size.width - 30.0)
        }
        
        return CGSize(width: width, height: 222.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.frame.size.width <= 320 {
            return (self.collectionView.frame.size.width - 315.0 - 30.0)
        }
        
        return (self.collectionView.frame.size.width - 315.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.frame.size.width <= 320 {
            return (self.collectionView.frame.size.width - 315.0 - 30.0)
        }
        
        return (self.collectionView.frame.size.width - 315.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.frame.size.width <= 320 {
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        
        return UIEdgeInsets(top: 0, left: (self.collectionView.frame.size.width - 315.0) / 2, bottom: 0, right: (self.collectionView.frame.size.width - 315.0) / 2)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = self.collectionView.contentOffset.x
        let w = self.collectionView.bounds.size.width
        newPage = Int(ceil(x/w))
        
        self.label_count.text = "\(newPage + 1)"
        
        print(newPage)
    }
}
