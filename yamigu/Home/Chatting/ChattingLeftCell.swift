//
//  ChattingLeftCell.swift
//  yamigu
//
//  Created by Yoon on 30/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class ChattingLeftCell: UICollectionViewCell {
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        return tv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage(named: "sample_profile")
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.roundCorners(corners: [.topLeft], radius: 10)
        iv.layer.cornerRadius = 21.0
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
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xFFF2E6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(timeLabel)
        addSubview(nameLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 42.0).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 13).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
        
        
        //x,y,w,h
        bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 13).isActive = true
        bubbleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -10).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10.0).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant:  10.0).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -10.0).isActive = true
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 6).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
