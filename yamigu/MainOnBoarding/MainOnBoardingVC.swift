//
//  MainOnBoardingVC.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import CHIPageControl
import KakaoCommon
import KakaoOpenSDK

class MainOnBoardingVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: CHIPageControlChimayo!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    
    var isSegue = false
    
    @IBOutlet weak var btn_start: UIButton!
    @IBOutlet weak var lbl_start: UILabel!
    let images = ["onBoarding_first", "onBoarding_second", "onBoarding_third", "onBoarding_fourth"]
    let titles = ["안전한 만남!", "간편한 만남!", "D-7 미팅!", "매칭 매니저와 함께!"]
    let descriptions = ["이름,나이,소속 인증을 통해\n확실하고 안전한 만남이 이뤄져요.", "미리 날짜와 장소를 정해\n매칭 이후에는 만나기만 하세요.", "오늘부터 일주일뒤까지\n7일 안에 빠르게 미팅하세요.", "미팅 신청부터 진행까지\n야미구 매니저가 만남을 도와줘요"]
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpUI()
        self.setUpPage()
        
        isSegue = false
        
        print("authKey = \(authKey)")
        
        if KOSession.shared()?.token?.accessToken != nil && authKey != "" {
            self.getUserInfo(urlString: "http://13.124.126.30:9999/api/user/info/")
            
        }
        
    }
    
    
    func setUpUI() {
        self.lbl_description.text = "이름,나이,소속 인증을 통해\n확실하고 안전한 만남이 이뤄져요."
        
        pageControl.currentPageTintColor = UIColor(rgb: 0xFF2B22)
        
        
        btn_start.isHidden = true
        lbl_start.isHidden = true
    }
    

    func setUpPage() {
        self.scrollView.delegate = self
        for index in 0..<4 {
            let subView = UIView()
            subView.frame = UIScreen.main.bounds
            
            // subView의 x좌표를 기기의 너비 * index만큼 주어 각 페이지의 시작 x좌표를 설정
            subView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
            scrollView.addSubview(subView)
            
            let mainImage = UIImageView(image: UIImage(named: images[index]))
            mainImage.frame.origin.x = (subView.bounds.width / 2 - (mainImage.frame.width / 2)) +  (UIScreen.main.bounds.width * CGFloat(index))
            mainImage.frame.origin.y = 138.0
            
            scrollView.addSubview(mainImage)
            
            let titleLabel = UILabel()
            titleLabel.text = titles[index]
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "Binggrae", size: 24.0)
            titleLabel.textColor = UIColor(rgb: 0xFF7B22)
            titleLabel.sizeToFit()
            
            titleLabel.frame.origin.x = (subView.bounds.width / 2 - (titleLabel.frame.width / 2)) +  (UIScreen.main.bounds.width * CGFloat(index))
            titleLabel.frame.origin.y = 351.0
            
            
            scrollView.addSubview(titleLabel)
            
            let descriptionsLabel = UILabel()
            descriptionsLabel.numberOfLines = 2
            descriptionsLabel.textAlignment = .center
            descriptionsLabel.font = UIFont(name: "NanumGothic", size: 14.0)
            descriptionsLabel.textColor = UIColor(rgb: 0x433E3E)
            descriptionsLabel.text = descriptions[index]
            descriptionsLabel.sizeToFit()
            descriptionsLabel.frame.size.width = subView.frame.width
            
            descriptionsLabel.frame.origin.x = (subView.bounds.width / 2 - (descriptionsLabel.frame.width / 2)) +  (UIScreen.main.bounds.width * CGFloat(index))
            descriptionsLabel.frame.origin.y = 412.0
            
            
            
            
            scrollView.addSubview(descriptionsLabel)
        }
        // scrollView에서 페이징이 가능하도록 설정
        scrollView.isPagingEnabled = true
        // scrollView의 contentSize를 5 페이지 만큼으로 설정
        
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * 4,
            height: height
        )
        scrollView.alwaysBounceVertical = false // 수직 스크롤 바운스 안되게 설정
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // floor 내림, ceil 올림
        // contentOffset는 현재 스크롤된 좌표
        let currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        let currentX = scrollView.contentOffset.x / UIScreen.main.bounds.width
        if( currentPage >= 0 ) {
            self.pageControl.set(progress: currentPage, animated: true)
        }
        
        print("pageNum = \(currentPage)")
        print("currentX = \(currentX)")
        
        if currentPage == 3 {
            btn_start.isHidden = false
            lbl_start.isHidden = false
            
            if( currentX > 3.2 ) {
                goNext()
            }
        } else {
            btn_start.isHidden = true
            lbl_start.isHidden = true
        }
    }
    
    func goNext() {
        if !isSegue {
            isSegue = true
            performSegue(withIdentifier: "segue_login", sender: self)
        }
        
        
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
                        if "\(newValue["nickname"]!)" == "<null>" {
                            print("is null")
                        }
                        else if newValue["nickname"] == nil {
                        } else {
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                } catch {
                    print(error)
                    // 회원가입 이력이 없는경우
                }
            }
            
        })
        task.resume()
    }
}
