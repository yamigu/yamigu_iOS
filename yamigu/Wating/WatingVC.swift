//
//  WatingVC.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class WatingVC: UIViewController, UIGestureRecognizerDelegate {
    
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: FilterView!
    
    @IBOutlet var dateButtons: [UIButton]!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var label_empty: UILabel!
    @IBOutlet weak var button_filter: UIBarButtonItem!
    @IBOutlet weak var constraint_tableViewLeading: NSLayoutConstraint!
    var isFilterShow = false
    var dateArray = [Date]()
    var selectedDate = [Date]()
    
    var selectedType = [Int]()
    var selectedPlace = [Int]()
    
    var selectedTmpType = [Int]()
    var selectedTmpPlace = [Int]()
    
    var selectedAge : [CGFloat] = [20.0, 31.0]
    var selectedTmpAge : [CGFloat] = [20.0, 31.0]
    
    @IBOutlet weak var backgroundTouchView: UIView!
    var matchingList = [Dictionary<String, Any>]()
    
    var selectedMatching = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(matchingList)
        
        setupTableView()
        backgroundVIew.isHidden = true
        height.constant = 0
        
        label_empty.isHidden = true
        
        //self.tableView.refreshControl
        
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
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDismiss))
        gesture.delegate = self
        backgroundTouchView.addGestureRecognizer(gesture)
        backgroundTouchView.isUserInteractionEnabled = true
    }
    
    @objc func backgroundViewDismiss() {
        isFilterShow = false
        
        
        height.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (comp) in
            if comp {
                self.backgroundVIew.isHidden = true
            }
        }
        
        self.filterView.compBtn.isHidden = true
        self.filterView.button_clear.isHidden = true
        
        self.filterView.slider.value = [20.0, 31.0]
        self.selectedAge = [20.0, 31.0]
        self.selectedTmpAge = [20.0, 31.0]
        self.filterView.slider.valueLabels[0].text = "20살"
        self.filterView.slider.valueLabels[1].text = "30+살"
        
        //self.selectedType = self.selectedTmpType
        //self.selectedPlace = self.selectedTmpPlace
        
        //makeBody()
    }
    
    @objc func refresh(_ sender: Any) {
        self.label_empty.isHidden = true
        
        self.makeBody()
    }
    
    @IBAction func showFilter(_ sender: Any) {
        if isFilterShow {
            isFilterShow = false
            
            
            height.constant = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (comp) in
                if comp {
                    self.backgroundVIew.isHidden = true
                }
            }
            
            self.filterView.compBtn.isHidden = true
            self.filterView.button_clear.isHidden = true
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
            
            
            self.updateUI()
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (comp) in
                if comp {
                    self.filterView.compBtn.isHidden = false
                    self.filterView.button_clear.isHidden = false
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.selectedTmpType.removeAll()
        self.selectedType.removeAll()
        self.selectedTmpPlace.removeAll()
        self.selectedPlace.removeAll()
        self.selectedDate.removeAll()
        self.selectedAge = [20.0, 31.0]
        self.selectedTmpAge = [20.0, 31.0]
        
        for btn in dateButtons {
            btn.isSelected = false
        }
        
        self.filterView.slider.value = [20.0, 31.0]
        self.selectedAge = [20.0, 31.0]
        self.selectedTmpAge = [20.0, 31.0]
        self.filterView.slider.valueLabels[0].text = "20살"
        self.filterView.slider.valueLabels[1].text = "30+살"
        
        self.button_filter.tintColor = UIColor(rgb: 0x505050)
        
        self.updateUI()
        
        if isFilterShow {
            self.showFilter(self)
        }
        
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
        for i in 0..<3 {
            self.filterView.button_types[i].isSelected = false
            self.filterView.button_types[i].backgroundColor = UIColor(rgb: 0xC6C6C6)
        }
        
        for i in 0..<6 {
            self.filterView.button_places[i].isSelected = true
            self.filterView.button_places[i].backgroundColor = UIColor(rgb: 0xC6C6C6)
        }
        
        if self.selectedPlace.count != 0 || self.selectedType.count != 0 {
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
        
        for type in selectedType {
            self.filterView.button_types[type - 1].isSelected = true
            self.filterView.button_types[type - 1].backgroundColor = UIColor(rgb: 0xFF7B22)
        }
        
        for place in selectedPlace {
            self.filterView.button_places[place - 1].isSelected = true
            self.filterView.button_places[place - 1].backgroundColor = UIColor(rgb: 0xFF7B22)
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
        
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
        DispatchQueue.main.async {
            cell.tv_description.centerVertically()
           
        }
        cell.layoutIfNeeded()
        
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
                cell.label_type.backgroundColor = UIColor(rgb: 0xFF7B22)
                cell.image_bottomBar.image = UIImage(named: "view_bottomBar")
                cell.button_meeting.backgroundColor = UIColor(rgb: 0xFF7B22)
                cell.rating.settings.filledColor = UIColor(rgb: 0xFF7B22)
                cell.rating.settings.filledBorderColor = UIColor(rgb: 0xFF7B22)
                cell.rating.settings.emptyBorderColor = UIColor(rgb: 0xFF7B22)
            } else if meeting_type == "2" {
                cell.label_type.text = "3:3 미팅"
                cell.label_type.backgroundColor = UIColor(rgb: 0xFF6024)
                cell.image_bottomBar.image = UIImage(named: "orange_bar_2")
                cell.button_meeting.backgroundColor = UIColor(rgb: 0xFF6024)
                cell.rating.settings.filledColor = UIColor(rgb: 0xFF6024)
                cell.rating.settings.filledBorderColor = UIColor(rgb: 0xFF6024)
                cell.rating.settings.emptyBorderColor = UIColor(rgb: 0xFF6024)
            } else if meeting_type == "3" {
                cell.label_type.text = "4:4 미팅"
                cell.label_type.backgroundColor = UIColor(rgb: 0xFF4600)
                cell.image_bottomBar.image = UIImage(named: "orange_bar_3")
                cell.button_meeting.backgroundColor = UIColor(rgb: 0xFF4600)
                cell.rating.settings.filledColor = UIColor(rgb: 0xFF4600)
                cell.rating.settings.filledBorderColor = UIColor(rgb: 0xFF4600)
                cell.rating.settings.emptyBorderColor = UIColor(rgb: 0xFF4600)
            }
            
            if meetingObj["is_matched"] as! Bool {
                cell.label_type.text = "매칭완료"
                cell.label_type.backgroundColor = UIColor(rgb: 0x707070)
                cell.image_bottomBar.image = UIImage(named: "gray_bar")
                cell.button_meeting.backgroundColor = UIColor(rgb: 0x707070)
                cell.rating.tintColor = UIColor(rgb: 0x707070)
                cell.rating.settings.filledColor = UIColor(rgb: 0x707070)
                cell.rating.settings.filledBorderColor = UIColor(rgb: 0x707070)
                cell.rating.settings.emptyBorderColor = UIColor(rgb: 0x707070)
            }
            
            let dateString = meetingObj["date"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            
            dateFormatter.dateFormat = "MM월 dd일"
            
            cell.label_date.text = dateFormatter.string(from: date!)
            
            let nickname = meetingObj["openby_nickname"] as! String
            let age = "\(meetingObj["openby_age"]!)"
            
            cell.label_nickname.text = nickname + " " + "(\(age))"
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
        
        if matchingList.count == 0 {
            //self.label_empty.isHidden = false
        } else {
            self.label_empty.isHidden = true
        }
        
        return matchingList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "watingTableViewCell") as! WatingTableViewCell
        DispatchQueue.main.async {
            cell.tv_description.centerVertically()
        }
        
        
        return 222.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WatingTableViewCell
        let meetingObj = self.matchingList[indexPath.section] as! Dictionary<String, Any>
        
        if meetingObj["is_matched"] as! Bool {
            
        } else {
            cell.button_meeting.isHidden = false
            
            cell.constraintHeight.constant = 54.5
            
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.layoutIfNeeded()
                
            }) { (complete) in
                cell.button_meeting.setTitle("미팅 신청하기", for: .normal)
            }
            
            self.selectedMatching = self.matchingList[indexPath.section] as! Dictionary<String, Any>
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WatingTableViewCell
        
        cell.button_meeting.setTitle("", for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            cell.constraintHeight.constant = 0
            cell.layoutIfNeeded()
        }) { (complete) in
            if complete {
                cell.button_meeting.isHidden = true
            }
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
        self.selectedDate.removeAll()
        self.selectedAge.removeAll()
        
        self.selectedTmpType.removeAll()
        self.selectedTmpPlace.removeAll()
        self.selectedTmpAge.removeAll()
        
        self.filterView.slider.value = [20.0, 31.0]
        self.selectedAge = [20.0, 31.0]
        self.selectedTmpAge = [20.0, 31.0]
        self.filterView.slider.valueLabels[0].text = "20살"
        self.filterView.slider.valueLabels[1].text = "30+살"
        
        for i in 0..<3 {
            self.filterView.button_types[i].isSelected = false
            self.filterView.button_types[i].backgroundColor = UIColor(rgb: 0xC6C6C6)
        }
        
        for i in 0..<6 {
            self.filterView.button_places[i].isSelected = true
            self.filterView.button_places[i].backgroundColor = UIColor(rgb: 0xC6C6C6)
        }
        
        for btn in dateButtons {
            btn.isSelected = false
        }
        
        self.makeBody()
    }
    
    func filterComp() {
        if isFilterShow {
            self.selectedPlace = self.selectedTmpPlace
            self.selectedType = self.selectedTmpType
            self.selectedAge = self.selectedTmpAge
            
            isFilterShow = false
            
            backgroundVIew.isHidden = true
            height.constant = 0
            
            self.makeBody()
        }
    }
    
    func typeBtnDeSelected(index: Int) {
        
        if let index = self.selectedTmpType.firstIndex(of: index) {
            self.selectedTmpType.remove(at: index)
        }
        
        //self.makeBody()
        self.checkCount()
    }
    
    func placeBtnDeSelected(index: Int) {
        
        if let index = self.selectedTmpPlace.firstIndex(of: index) {
            self.selectedTmpPlace.remove(at: index)
        }
        //self.makeBody()
        self.checkCount()
    }
    
    func typeBtnPressed(index: Int) {
        self.selectedTmpType.append(index)
        //self.makeBody()
        self.checkCount()
    }
    
    func plceBtnPressed(index: Int) {
        self.selectedTmpPlace.append(index)
        //self.makeBody()
        self.checkCount()
    }
    
    func slideValueChanged(value: [CGFloat]) {
        print(index)
        
        self.selectedTmpAge = value
        print("selectedAge = \(selectedTmpAge)")
        
        self.checkCount()
    }
    
    func checkCount() {
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
        
        if selectedTmpType.count == 0 {
            body += "type=1&type=2&type=3&"
        }
        
        for tp in self.selectedTmpType {
            body += "type=\(tp)&"
        }
        
        if selectedTmpPlace.count == 0 {
            body += "place=1&place=2&place=3&"
        }
        
        for pc in self.selectedTmpPlace {
            body += "place=\(pc)&"
        }
        
        //body.removeLast()
        
        let minimum_age = Int(self.selectedTmpAge[0] - 20.0)
        let maximum_age = Int(self.selectedTmpAge[1] - 20.0)
        
        body += "minimum_age=\(minimum_age)&"
        body += "maximum_age=\(maximum_age)"
        
        let escapedString = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        self.getTmpMeetingCount(urlString:"http://106.10.39.154:9999/api/meetings/waiting/?\(escapedString!)")
        
        //self.updateUI()
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
            body += "place=1&place=2&place=3&"
        }
        
        for pc in self.selectedPlace {
            body += "place=\(pc)&"
        }
        
        //body.removeLast()
        
        let minimum_age = Int(self.selectedAge[0] - 20.0)
        let maximum_age = Int(self.selectedAge[1] - 20.0)
        
        body += "minimum_age=\(minimum_age)&"
        body += "maximum_age=\(maximum_age)"
        
        let escapedString = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        self.getMeetingCount(urlString:"http://106.10.39.154:9999/api/meetings/waiting/?\(escapedString!)")
        
        self.updateUI()
        
        let const = 12.5 + self.tableView.frame.width
        self.constraint_tableViewLeading.constant = const
        self.view.layoutIfNeeded()
        
        self.constraint_tableViewLeading.constant = 12.5
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        print("http://106.10.39.154:9999/api/meetings/count/?\(escapedString!)")
        
    }
    
    func getTmpMeetingCount(urlString : String) {
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
                        
                        let result = newValue["results"] as! [Dictionary<String, Any>]
                        self.filterView.compBtn.setTitle("\(result.count)팀 보기", for: .normal)
                        
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
                        self.refreshControl.endRefreshing()
                        
                        if self.matchingList.count == 0 {
                            self.label_empty.isHidden = false
                        }
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
        
        
        self.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
        
        //self.postRequest("http://106.10.39.154:9999/api/matching/send_request/", bodyString: "meeting_type=\(meeting_type)&date=\(dateString)&place=\(place)&meeting_id=\(meeting_id)")
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
                        } else {
                            
                        }
                        //self.dismiss(animated: false, completion: nil)
                    }
                } catch {
                    print(error)
                    
                    
                }
            }
        }.resume()
    }
    
    func getMyMeeting(urlString : String) {
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
                        var myMeetings = [Dictionary<String, Any>]()
                        var myMeeting = Dictionary<String, Any>()
                        
                        for value in newValue {
                            
                            if (value["is_matched"] as! Bool) {
                            } else {
                                myMeetings.append(value)
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                var date = Date()
                                date = dateFormatter.date(from: "\(value["date"]!)")!
                                
                                dateFormatter.dateFormat = "MM월 d일"
                                let dateString = dateFormatter.string(from: date)
                                
                                let dateFormatter2 = DateFormatter()
                                dateFormatter2.dateFormat = "yyyy-MM-dd"
                                
                                var date2 = Date()
                                date2 = dateFormatter2.date(from: "\(self.selectedMatching["date"]!)")!
                                
                                dateFormatter2.dateFormat = "MM월 d일"
                                let dateString2 = dateFormatter2.string(from: date2)
                                
                                if dateString == dateString2 {
                                    myMeeting = value
                                }
                            }
                        }
                        
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
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateFormat = "yyyy-MM-dd"
                        
                        var date2 = Date()
                        date2 = dateFormatter2.date(from: "\(self.selectedMatching["date"]!)")!
                        
                        dateFormatter2.dateFormat = "MM월 d일"
                        let dateString2 = dateFormatter2.string(from: date2)
                        
                        if myMeeting == nil {
                            self.postRequest("http://106.10.39.154:9999/api/matching/send_request/", bodyString: "meeting_type=\(meeting_type)&date=\(dateString2)&place=\(place)&meeting_id=\(meeting_id)")
                        } else {
                            let myMeeting_type = "\(myMeeting["meeting_type"]!)"
                            let myMeeting_place = "\(myMeeting["place_type"]!)"
                            
                            if ((myMeeting_type != meeting_type) || myMeeting_place != place) {
                                self.view.makeToast("미팅 타입과 장소가 달라요!")
                            } else {
                                self.postRequest("http://106.10.39.154:9999/api/matching/send_request/", bodyString: "meeting_type=\(meeting_type)&date=\(dateString2)&place=\(place)&meeting_id=\(meeting_id)")
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                } catch {
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
}
