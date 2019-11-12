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

class MainTC: UITabBarController {
    
    let menuButton = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        self.performSegue(withIdentifier: "segue_registermeeting", sender: self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.height - self.view.safeAreaInsets.bottom
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
