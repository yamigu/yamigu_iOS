//
//  NotisVC.swift
//  yamigu
//
//  Created by ph7164 on 11/11/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class NotisVC: UIViewController {
    
    let typeString = ["", "신청!", "매칭!", "거절!", "대기!", "완료!", "취소!"]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension NotisVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarmDicts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let alarmDic = alarmDicts[indexPath.section]
        
        let type = cell.viewWithTag(1) as! UILabel
        let description = cell.viewWithTag(2) as! UILabel
        let time = cell.viewWithTag(3) as! UILabel
        
        type.text = self.typeString[Int(alarmDic["type"] as! Int)]
        description.text = alarmDic["content"] as! String
        
        let dateString =  "\(alarmDic["time"]!)"
        let dateDoube = Double(dateString)! / 1000.0
        print("datedouble = \(dateDoube)")
        let date = Date(timeIntervalSince1970: dateDoube as! TimeInterval)
        let dateFomatter = DateFormatter(format: "a KK:mm")
        dateFomatter.locale = Locale(identifier: "ko_kr")
        dateFomatter.timeZone = TimeZone(abbreviation: "KST")
        //cell.timeLabel.text = dateFomatter.string(from: date).replacingOccurrences(of: "00", with: "12")
         
        if daysBetween(start: date, end: Date()) > 0 {
            time.text = "1일전"
        } else if daysBetween(start: date, end: Date()) > 30 {
            time.text = "1달전"
        } else {
            time.text = "\(Int(minutesBetweenDates(oldDate: date, newDate: Date())))분전"
            
            if (Int(minutesBetweenDates(oldDate: date, newDate: Date()))) >= 60 {
                time.text = "\(Int(minutesBetweenDates(oldDate: date, newDate: Date()))/60)시간전"
            }
        }
         
         
                  
         
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 4.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "segue_noticeDetail", sender: self)
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
    
    func minutesBetweenDates(oldDate: Date, newDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60

        //then return the difference
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
}
