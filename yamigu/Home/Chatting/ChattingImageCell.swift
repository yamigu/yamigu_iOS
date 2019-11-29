//
//  ChattingImageCell.swift
//  yamigu
//
//  Created by Yoon on 30/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

protocol ChattingImageCellDelegate: class {
    func viewRecomandPlace()
}

class ChattingImageCell: UICollectionViewCell {
    weak var delegate : ChattingImageCellDelegate?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "지역별로 야미구에서 만나기 좋은 매장을 추천해주고 있어요!\n\n아래 추천 매장에서 만나 보세요!"
        tv.font = UIFont.init(name: "Binggrae", size: 10.0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage(named: "sample_profile")
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.roundCorners(corners: [.topLeft], radius: 10)
        iv.layer.cornerRadius = 10.0
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.init(name: "Binggrae", size: 9)
        lb.textColor = UIColor(rgb: 0xFF7B22)
        lb.text = "야미구 매니저 sub"
        
        return lb
    }()
    
    let timeLabel : UILabel = {
        let lb = UILabel()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.init(name: "NanumGothic", size: 10)
        lb.textColor = UIColor(rgb: 0x20252C)
        lb.text = "오후 6:07"
        
        return lb
    }()
    
    let titleLabel : UILabel = {
        let lb = UILabel()
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.init(name: "Binggrae", size: 20)
        lb.textColor = UIColor(rgb: 0xFF7B22)
        lb.text = "장소를 정해주세요"
        
        return lb
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xFFF2E6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let shopButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.init(name: "Binggrae", size: 14)
        button.setTitle("추천 매장 보기", for: .normal)
        button.setTitleColor(UIColor(rgb: 0xFF7B22), for: .normal)
        button.layer.borderColor = UIColor(rgb: 0xFF7B22).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        button.isUserInteractionEnabled = true
        
        
        return button
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    @objc func shopButtonPressed() {
        print("button pressed")
        
        self.delegate?.viewRecomandPlace()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(bubbleView)
        bubbleView.addSubview(titleLabel)
        
        addSubview(textView)
        addSubview(timeLabel)
        addSubview(nameLabel)
        addSubview(shopButton)
        
        shopButton.addTarget(self, action: #selector(shopButtonPressed), for: .touchUpInside)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 42.0).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 13).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
        
        
        //x,y,w,h
        bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 13).isActive = true
        bubbleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        //bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 230)
        //bubbleWidthAnchor?.isActive = true
        
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor, constant: 0).isActive = true
        
        shopButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor, constant: 0).isActive = true
        shopButton.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10).isActive = true
        shopButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        shopButton.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10.0).isActive = true
        textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:  7.0).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -10.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: shopButton.topAnchor, constant: 11).isActive = true
        //textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 6).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
