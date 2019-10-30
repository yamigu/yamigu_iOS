//
//  HomeVC.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

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
    
    var selectedMyMeeting = Dictionary<String, Any>()
    
    let meetingType = ["2:2 소개팅", "3:3 미팅", "4:4 미팅"]
    let places = ["신촌/홍대", "건대/왕십리", "강남", "수원역", "인천 송도", "부산 서면"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupCollectionView()
        
        self.getTodayMeeting(urlString: "http://147.47.208.44:9999/api/meetings/today/")
        self.getMyMeeting(urlString: "http://147.47.208.44:9999/api/meetings/my/")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTodayMeeting(urlString: "http://147.47.208.44:9999/api/meetings/today/")
        self.getMyMeeting(urlString: "http://147.47.208.44:9999/api/meetings/my/")
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
                        for value in newValue {
                            self.myMeetings.append(value)
                        }
                        
                        if self.myMeetings.count == 0 {
                            self.button_addMeeting.isHidden = false
                            self.topConstraint.constant = 107
                        } else {
                            self.button_addMeeting.isHidden = true
                            self.topConstraint.constant = 15.5
                        }
                        
                        self.myMeetingTableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_matching" {
            let destination = segue.destination as! UINavigationController
            let des = destination.visibleViewController as! MatchVC
            
            des.matchingDict = self.selectedMyMeeting
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeMyTableViewCell") as! HomeMyTableViewCell
            cell.delegate = self
            cell.index = indexPath.section
            let meetingDict = myMeetings[indexPath.section]
            cell.label_type.text = self.meetingType[Int((meetingDict["meeting_type"] as! Int) - 1)]
            cell.label_place.text = meetingDict["place_type_name"] as! String
            
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
        
        var height = 211.0 * Double(mymeetingCount) + 16.0 * Double(mymeetingCount - 1)
        
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
}

extension HomeVC : HomeTalbeViewDelegate {
    func viewApplyList(index: Int) {
        self.selectedMyMeeting = self.myMeetings[index]
        
        self.performSegue(withIdentifier: "segue_matching", sender: self)
    }
    
    func viewWatingList(index: Int) {
        
    }
    
    func edit(index: Int) {
        
    }
    
    
    
}
