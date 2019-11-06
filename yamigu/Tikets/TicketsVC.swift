//
//  TiketsVC.swift
//  yamigu
//
//  Created by Yoon on 21/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import CHIPageControl

class TicketsVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: CHIPageControlChimayo!
    
    let images = ["ticket_first", "ticket_second", "ticket_third"]
    let titles = ["새로운 이성과의\n설레는 야미구", "친구들과 부담없이\n즐기는 야미구", "처음이어도\n괜찮은 야미구"]
    let descriptions = ["야미구는 채팅이 아닌\n만남을 제공해요.", "함께 나가는 친구들과 나누세요.\n(*카카오 더치페이 추천)", "매니저가 친절하게 알려줄게요.\n(*꿀팁은 덤!)"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPage()
    }
    
    func setUpPage() {
        self.scrollView.delegate = self
        for index in 0..<3 {
            let subView = UIView()
            
            subView.frame = UIScreen.main.bounds
                //self.scrollView.bounds
                //UIScreen.main.bounds
            
            // subView의 x좌표를 기기의 너비 * index만큼 주어 각 페이지의 시작 x좌표를 설정
            subView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
            scrollView.addSubview(subView)
            
            let mainImage = UIImageView(image: UIImage(named: images[index]))
            mainImage.frame.origin.x = (subView.bounds.width / 2 - (mainImage.frame.width / 2)) +  (UIScreen.main.bounds.width * CGFloat(index))
            mainImage.frame.origin.y = 187.0
            
            scrollView.addSubview(mainImage)
            
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 2
            titleLabel.text = titles[index]
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "Binggrae", size: 31.0)
            titleLabel.textColor = UIColor(rgb: 0xFF7B22)
            titleLabel.sizeToFit()
            
            titleLabel.frame.origin.x = (subView.bounds.width / 2 - (titleLabel.frame.width / 2)) +  (UIScreen.main.bounds.width * CGFloat(index))
            titleLabel.frame.origin.y = 54.0
            
            
            scrollView.addSubview(titleLabel)
            
            let descriptionsLabel = UILabel()
            descriptionsLabel.numberOfLines = 2
            descriptionsLabel.textAlignment = .center
            descriptionsLabel.font = UIFont(name: "NanumGothic", size: 18.0)
            descriptionsLabel.textColor = UIColor(rgb: 0x433E3E)
            descriptionsLabel.text = descriptions[index]
            descriptionsLabel.sizeToFit()
            descriptionsLabel.frame.size.width = subView.frame.width
            
            descriptionsLabel.frame.origin.x = (subView.bounds.width / 2 - (descriptionsLabel.frame.width / 2)) +  (UIScreen.main.bounds.width * CGFloat(index))
            descriptionsLabel.frame.origin.y = 357.0
            
            
            
            
            scrollView.addSubview(descriptionsLabel)
        }
        // scrollView에서 페이징이 가능하도록 설정
        scrollView.isPagingEnabled = true
        // scrollView의 contentSize를 5 페이지 만큼으로 설정
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * 3,
            height: height
            //height
            //self.scrollView.bounds.height
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
        
        //self.mainImage.image = UIImage(named: images[currentPage])
        //self.lbl_description.text = descriptions[currentPage]
        //self.lbl_title.text = descriptions[currentPage]
        print("pageNum = \(currentPage)")
        print("currentX = \(currentX)")
        
    }

    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
