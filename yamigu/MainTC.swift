//
//  MainTC.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoCommon
import KakaoOpenSDK
import FirebaseDatabase

var alarmDicts = Array<Dictionary<String, Any>>()
var alarmCount = 0
var badgeCount = 0

class TabBar: UITabBar {
    
}

class MainTC: UITabBarController {
    
    let menuButton = UIButton(frame: CGRect.zero)
    
    var ref: DatabaseReference!
    var refHandle : DatabaseHandle!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
        menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.height - self.view.safeAreaInsets.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        
        ref = Database.database().reference()
        refHandle = ref.child("user").child(userDictionary["uid"]! as! String).child("notifications").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.children.allObjects as? [DataSnapshot] {
                alarmCount = 0
                alarmDicts.removeAll()
                for dict in dictionary {
                    if let data = dict.value as? Dictionary<String, Any> {

                        alarmDicts.append(data)
                        print("data = \(data)")
                        
                        if data["isUnread"] as! Bool {
                            alarmCount += 1
                        }
                    }
                }
                badgeCount = alarmCount
                UIApplication.shared.applicationIconBadgeNumber = badgeCount
                alarmDicts.reverse()
                let homeController = self.viewControllers![0] as! HomeVC
                if homeController != nil {
                    homeController.updateAlarmCountLabel()
                }
                let mypageNavController = self.viewControllers![3] as! UINavigationController
                let mypageController = mypageNavController.topViewController as! MyPageVC
                if mypageController != nil {
                    mypageController.updateAlarmCountButton()
                }
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if KOSession.shared()?.token?.accessToken != nil {
            let access_token = (KOSession.shared()?.token?.accessToken)!
            print("access token2 = \(access_token)")
            self.postRequest("http://106.10.39.154:9999/api/oauth/kakao/", bodyString: "access_token=\(access_token)")
            
            //performSegue(withIdentifier: "segue_onboarding", sender: self)
        }
        
        let homeController = self.viewControllers![0] as! HomeVC
        if homeController != nil {
            homeController.myMeetings.removeAll()
            homeController.getMyMeeting(urlString: "http://106.10.39.154:9999/api/meetings/my/")
        }
    }
    
    
    func adjustImageAndTitleOffsetsForButton (button: UIButton) {
        
        let spacing: CGFloat = 4.0
        let imageSize = button.imageView!.frame.size
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        let titleSize = button.titleLabel!.frame.size
        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func setupMiddleButton() {
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        menuButton.frame = CGRect(x: 0, y: 0, width: tabBarItemSize.width, height: tabBar.frame.size.height)
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height - self.view.safeAreaInsets.bottom
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        menuButton.backgroundColor = UIColor(rgb:0xFF4D00)
        
        menuButton.setImage(UIImage(named: "bar_icon_cross"), for: .normal)
        menuButton.setTitle("0/3", for: .normal)
        menuButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        
        self.adjustImageAndTitleOffsetsForButton(button: menuButton)
        menuButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        
        self.view.addSubview(menuButton)
        self.view.layoutIfNeeded()
        
        
    }
    
    @objc func pressed(sender: UIButton!) {
        if (userDictionary["user_certified"] as! Int == 0) {
            let alert = UIAlertController(title: "", message: "소속을 인증해야 미팅 할 수 있어요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else if (userDictionary["user_certified"] as! Int == 1) {
            let alert = UIAlertController(title: "", message: "인증이 진행중이에요!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if menuButton.titleLabel?.text == "3/3" {
                self.view.makeToast("미팅은 일주일에 3번까지만 가능해요!")
            } else {
                self.performSegue(withIdentifier: "segue_registermeeting", sender: self)
            }
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
                        // 동작 실행
                        authKey = newValue["key"]!
                        
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
    }

}
