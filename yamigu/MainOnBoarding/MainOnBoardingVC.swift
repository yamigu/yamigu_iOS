//
//  MainOnBoardingVC.swift
//  yamigu
//
//  Created by Yoon on 29/09/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import CHIPageControl

class MainOnBoardingVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: CHIPageControlChimayo!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    
    @IBOutlet weak var btn_start: UIButton!
    @IBOutlet weak var lbl_start: UILabel!
    let images = ["onBoarding_first", "onBoarding_second", "onBoarding_third", "onBoarding_fourth"]
    let titles = ["안전한 만남!", "간편한 만남!", "D-7 미팅!", "매칭 매니저와 함께!"]
    let descriptions = ["이름,나이,소속 인증을 통해\n확실하고 안전한 만남이 이뤄져요.", "미리 날짜와 장소를 정해\n매칭 이후에는 만나기만 하세요.", "오늘부터 일주일뒤까지\n7일 안에 빠르게 미팅하세요.", "미팅 신청부터 진행까지\n야미구 매니저가 만남을 도와줘요"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
        self.setUpPage()
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
        }
        // scrollView에서 페이징이 가능하도록 설정
        scrollView.isPagingEnabled = true
        // scrollView의 contentSize를 5 페이지 만큼으로 설정
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * 4,
            height: UIScreen.main.bounds.height
        )
        scrollView.alwaysBounceVertical = false // 수직 스크롤 바운스 안되게 설정
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // floor 내림, ceil 올림
        // contentOffset는 현재 스크롤된 좌표
        let currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        self.pageControl.set(progress: currentPage, animated: true)
        self.mainImage.image = UIImage(named: images[currentPage])
        self.lbl_description.text = descriptions[currentPage]
        self.lbl_title.text = descriptions[currentPage]
        
        if currentPage == 3 {
            btn_start.isHidden = false
            lbl_start.isHidden = false
        } else {
            btn_start.isHidden = true
            lbl_start.isHidden = true
        }
    }
}
