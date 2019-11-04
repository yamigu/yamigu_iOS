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
    
    @IBOutlet weak var label_count: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button_left: UIButton!
    @IBOutlet weak var button_right: UIButton!
    
    var newPage = 0
    
    var matchingDict : Dictionary<String, Any>!
    
    var receiveMatchingList = [Dictionary<String, Any>]()
    var requestMatchingList = [Dictionary<String, Any>]()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.button_receive.isSelected = true
        
        self.button_left.setTitle("미팅하기", for: .normal)
        self.button_right.setTitle("거절하기", for: .normal)
        
        let date = self.matchingDict["date"] as! String
        var type = ""
        let tmpType = "\(self.matchingDict["meeting_type"]!)"
        if tmpType == "1" {
            type = "2:2 소개팅"
        } else if tmpType == "2" {
            type = "3:3 미팅"
        } else if tmpType == "3" {
            type = "4:4 미팅"
        }
        let place = self.matchingDict["place_type_name"] as! String
        self.title = date + " || " + place + " || " + type
        
        let id = "\(self.matchingDict["id"]!)"
        
        self.getReceiveMatching(urlString: "http://147.47.208.44:9999/api/matching/received_request/?meeting_id=\(id)")
        self.getRequestMatching(urlString: "http://147.47.208.44:9999/api/matching/sent_request/?meeting_id=\(id)")
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
        
        self.button_left.setTitle("미팅하기", for: .normal)
        self.button_right.setTitle("거절하기", for: .normal)
        
    }
    @IBAction func requestBtnPressed(_ sender: Any) {
        self.button_receive.isSelected = false
        self.button_request.isSelected = true
        
        self.button_left.setTitle("대기중", for: .normal)
        self.button_right.setTitle("취소하기", for: .normal)
        
    }
    @IBAction func leftBtnPressed(_ sender: Any) {
        if button_left.titleLabel?.text! == "미팅하기" {
            print(button_left.titleLabel?.text)
        } else if button_left.titleLabel?.text! == "대기중" {
            print(button_left.titleLabel?.text)
        }
        
    }
    @IBAction func rightBtnPressed(_ sender: Any) {
        if button_right.titleLabel?.text! == "거절하기" {
            print(button_right.titleLabel?.text)
        } else if button_right.titleLabel?.text! == "취소하기" {
            print(button_right.titleLabel?.text)
        }
    }
    
    func postRequest(_ urlString: String, bodyString: String){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
        request.httpBody = body
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
            
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)
                    print(str)
                    
                    DispatchQueue.main.async {
                        print(str)
                    }
                }
            }else{
                print("data nil")
            }
        })
        task.resume()
    }
    
    func getReceiveMatching(urlString : String) {
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
            
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)
                   
                    DispatchQueue.main.async {
                        print(str)
                    }
                }
            }else{
                print("data nil")
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCell", for: indexPath) as! MatchCell
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 315.0, height: 222.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.collectionView.frame.size.width - 315.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (self.collectionView.frame.size.width - 315.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (self.collectionView.frame.size.width - 315.0) / 2, bottom: 0, right: (self.collectionView.frame.size.width - 315.0) / 2)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = self.collectionView.contentOffset.x
        let w = self.collectionView.bounds.size.width
        newPage = Int(ceil(x/w))
        
        print(newPage)
    }
}
