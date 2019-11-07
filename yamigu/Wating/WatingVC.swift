//
//  WatingVC.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class WatingVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: FilterView!
    
    @IBOutlet var dateButtons: [UIButton]!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var button_filter: UIBarButtonItem!
    var isFilterShow = false
    var dateArray = [Date]()
    var selectedDate = [Date]()
    
    var selectedType = [Int]()
    var selectedPlace = [Int]()
    
    var matchingList = [Dictionary<String, Any>]()
    
    var selectedMatching = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(matchingList)
        
        setupTableView()
        backgroundVIew.isHidden = true
        height.constant = 0
        
        self.filterView.delegate = self
        
        var date = Date()
        var dateComponents = DateComponents()
        
        for i in 0..<7 {
            dateComponents.setValue(i, for: .day);
            let dt = Calendar.current.date(byAdding: dateComponents, to: date)!
            
            let dtformatter = DateFormatter()
            dtformatter.dateFormat = "yyyy-MM-dd"
            let dtString = dtformatter.string(from: dt)
            
            let resultDt = dtformatter.date(from: dtString)
            
            dateArray.append(resultDt!)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        
        for btn in dateButtons {
            let dt = dateArray[btn.tag]
            btn.setTitle(formatter.string(from: dt), for: .normal)
            btn.setTitleColor(UIColor(rgb: 0x000000), for: .normal)
            btn.setTitleColor(UIColor(rgb: 0xFF7B22), for: .selected)
            btn.tintColor = .clear
            btn.backgroundColor = .clear
        }
        self.updateUI()
        
        
    }
    @IBAction func showFilter(_ sender: Any) {
        if isFilterShow {
            isFilterShow = false
            
            backgroundVIew.isHidden = true
            height.constant = 0
        } else {
            isFilterShow = true
            
            backgroundVIew.isHidden = false
            height.constant = 424
            
            for type in selectedType {
                self.filterView.button_types[type - 1].isSelected = true
                self.filterView.button_types[type - 1].backgroundColor = UIColor(rgb: 0xFF7B22)
            }
            
            for place in selectedPlace {
                self.filterView.button_places[place - 1].isSelected = true
                self.filterView.button_places[place - 1].backgroundColor = UIColor(rgb: 0xFF7B22)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.makeBody()
        
    }
    
    @IBAction func dateBtnPressed(_ sender: Any) {
        let btn = sender as! UIButton
        print("is selected = \(btn.isSelected)")
        
        if btn.isSelected {
            if let index = self.selectedDate.firstIndex(of: self.dateArray[btn.tag]) {
                self.selectedDate.remove(at: index)
            }
            btn.isSelected = false
            
            
            
        } else {
            btn.isSelected = true
            
            self.selectedDate.append(self.dateArray[btn.tag])
        }
        
        self.makeBody()
        print(self.selectedDate)
    }
    
    
    func updateUI() {
        if self.selectedPlace.count != 0 || self.selectedDate.count != 0 || self.selectedType.count != 0 {
            self.button_filter.tintColor = UIColor(rgb: 0xFF7B22)
        } else {
            self.button_filter.tintColor = UIColor(rgb: 0x505050)
        }
    
        if( self.dateArray.count != 0 ) {
            for i in 0..<7 {
                let date = self.dateArray[i]
                
                let formatter = DateFormatter()
                formatter.dateFormat = "M/d"
                
                for dt in selectedDate {
                    if formatter.string(from: dt) == formatter.string(from: date) {
                        DispatchQueue.main.async {
                            self.dateButtons[i].isSelected = true
                        }
                    }
                }

            }
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_editMeeting" {
            let destination = segue.destination as! UINavigationController
            let des = destination.visibleViewController as! RegisterMeetingVC
            
            des.isEdit = true
            des.isRequest = true
            des.meetingDict = self.selectedMatching
        }
    }
}

extension WatingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "watingTableViewCell", for: indexPath) as! WatingTableViewCell
        cell.layer.cornerRadius = 10.0
        cell.cornerradius = 10.0
        cell.clipsToBounds = true
        cell.tv_description.centerVertically()
        
        if self.matchingList.count != 0 {
            let meetingObj = self.matchingList[indexPath.section] as! Dictionary<String, Any>
            
            if let imageUrl = URL(string: "\(meetingObj["openby_profile"]!)") {
                print("openby_profile = \(meetingObj["openby_profile"]!)")
                cell.image_profile.downloaded(from: imageUrl)
            }
            
            cell.constraintHeight.constant = 0.0
            cell.button_meeting.isHidden = true
            
            cell.delegate = self
            
            let meeting_type = "\(meetingObj["meeting_type"]!)"
            if meeting_type == "1" {
                cell.label_type.text = "2:2 소개팅"
            } else if meeting_type == "2" {
                cell.label_type.text = "3:3 미팅"
            } else if meeting_type == "3" {
                cell.label_type.text = "4:4 미팅"
            }
            let dateString = meetingObj["date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            dateFormatter.dateFormat = "MM월 dd일"
            
            cell.label_date.text = dateFormatter.string(from: date!)
            
            let nickname = meetingObj["openby_nickname"] as! String
            let age = "\(meetingObj["openby_age"]!)"
            
            cell.label_nickname.text = nickname + age
            cell.label_place.text = meetingObj["place_type_name"] as! String
            
            let belong = meetingObj["openby_belong"] as! String
            let department = meetingObj["openby_department"] as! String
            
            cell.label_belong.text = belong + " " + department
            
            cell.tv_description.text = meetingObj["appeal"] as! String
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 21.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return matchingList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WatingTableViewCell
        
        cell.button_meeting.isHidden = false
        
        cell.constraintHeight.constant = 54.5
        UIView.animate(withDuration: 0.5) {
            cell.layoutIfNeeded()
        }
        
        self.selectedMatching = self.matchingList[indexPath.section] as! Dictionary<String, Any>
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WatingTableViewCell
        
        cell.button_meeting.isHidden = true
        
        cell.constraintHeight.constant = 0
        
        UIView.animate(withDuration: 0.5) {
            cell.layoutIfNeeded()
        }
        
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "WatingTableViewCell", bundle: nil), forCellReuseIdentifier: "watingTableViewCell")
    }
}

extension WatingVC: FilterViewDelegate {
    func filterClearAll() {
        self.selectedType.removeAll()
        self.selectedPlace.removeAll()
    }
    
    func filterComp() {
        if isFilterShow {
            isFilterShow = false
            
            backgroundVIew.isHidden = true
            height.constant = 0
        }
    }
    
    func typeBtnDeSelected(index: Int) {
        
        if let index = self.selectedType.firstIndex(of: index) {
            self.selectedType.remove(at: index)
        }
        
        self.makeBody()
    }
    
    func placeBtnDeSelected(index: Int) {
        
        if let index = self.selectedPlace.firstIndex(of: index) {
            self.selectedPlace.remove(at: index)
        }
        self.makeBody()
    }
    
    func typeBtnPressed(index: Int) {
        self.selectedType.append(index)
        self.makeBody()
    }
    
    func plceBtnPressed(index: Int) {
        self.selectedPlace.append(index)
        self.makeBody()
    }
    
    func slideValueChanged(value: [CGFloat]) {
        print(index)
    }
    
    func makeBody() {
        var body = ""
        
        
        if selectedDate.count == 0 {
            for dt in self.dateArray {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                body += "date=\(formatter.string(from: dt))&"
            }
        }
        
        
        for dt in self.selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            body += "date=\(formatter.string(from: dt))&"
        }
        
        if selectedType.count == 0 {
            body += "type=1&type=2&type=3&"
        }
        
        for tp in self.selectedType {
            body += "type=\(tp)&"
        }
        
        if selectedPlace.count == 0 {
            body += "place=1&place=2&place=3&place=4&place=5&place=6&"
        }
        
        for pc in self.selectedPlace {
            body += "place=\(pc)&"
        }
        
        body.removeLast()
        let escapedString = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        self.getMeetingCount(urlString:"http://147.47.208.44:9999/api/meetings/waiting/?\(escapedString!)")
        
        self.updateUI()
        
        print("http://147.47.208.44:9999/api/meetings/count/?\(escapedString!)")
        
    }
    
    func getMeetingCount(urlString : String) {
        matchingList.removeAll()
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "get"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            //print(response)
            
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            
            if let data = data {
                print(data)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                    
                    guard let newValue = json as? Dictionary<String, Any> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    print(newValue)
                    
                    DispatchQueue.main.async {
                        
                        self.matchingList = newValue["results"] as! [Dictionary<String, Any>]
                        self.filterView.compBtn.setTitle("\(self.matchingList.count)팀 보기", for: .normal)
                        
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            
        })
        task.resume()
        /*if let _data = data {
         if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
         let str = String(strData)
         print(str)
         
         DispatchQueue.main.async {
         
         }
         }
         }else{
         print("data nil")
         }
         }).resume()*/
        
    }
    
    
}

extension WatingVC: WatingTableViewDelegate {
    func meetingBtnPressed() {
        //- meeting_type: 미팅 타입
        //- date: 날짜
        //- place: 장소
        //- appeal: 어필 문구
        //- receiver: 신청 대상 미팅 -> meeting_id
        let meeting_type = "\(self.selectedMatching["meeting_type"]!)"
        //let date = "\(self.selectedMatching["date"]!)"
        let place = "\(self.selectedMatching["place_type"]!)"
        let appeal = "\(self.selectedMatching["appeal"]!)"
        let meeting_id = "\(self.selectedMatching["id"]!)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var date = Date()
        date = dateFormatter.date(from: "\(self.selectedMatching["date"]!)")!
        
        dateFormatter.dateFormat = "MM월 d일"
        let dateString = dateFormatter.string(from: date)
        
        self.postRequest("http://147.47.208.44:9999/api/matching/send_request/", bodyString: "meeting_type=\(meeting_type)&date=\(dateString)&place=\(place)&meeting_id=\(meeting_id)")
    }
    
    func postRequest(_ urlString: String, bodyString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: true)
        request.httpBody = body
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
                        let message = newValue["message"] as! String
                        if message == "You should create new meeting for matching" {
                            self.performSegue(withIdentifier: "segue_editMeeting", sender: self)
                        }
                        //self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print(error)
                    
                    
                }
            }
        }.resume()
    }
    
}
