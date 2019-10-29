//
//  ChattingVC.swift
//  yamigu
//
//  Created by Yoon on 26/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class ChattingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChattingCell
        
        let text = "안녕하세요 :)\n만남을 도와줄 매칭 매니저 sub입니다.\n아래 내용을 꼭 참고해주세요\n*채팅내에서 자유롭게 약속을 수정하셔도 됩니다.\n*개인 연락처 교환시 야미구 미팅에서 벗어나 모든 책임 및 환불제도에서 제외됩니다.\n매니저가 필요하거나 궁금한점이 생기면 언제든 좌측 하단 아이콘을 눌러주세요!"
        cell.textView.text = text
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
        //cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height somehow????
        let text = "안녕하세요 :)\n만남을 도와줄 매칭 매니저 sub입니다.\n아래 내용을 꼭 참고해주세요\n*채팅내에서 자유롭게 약속을 수정하셔도 됩니다.\n*개인 연락처 교환시 야미구 미팅에서 벗어나 모든 책임 및 환불제도에서 제외됩니다.\n매니저가 필요하거나 궁금한점이 생기면 언제든 좌측 하단 아이콘을 눌러주세요!"
        height = estimateFrameForText(text).height + 70
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ChattingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.init(name: "NanumGothic", size: 14.0)]), context: nil)
    }
    
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
}
