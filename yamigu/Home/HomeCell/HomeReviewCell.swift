//
//  HomeReviewCell.swift
//  yamigu
//
//  Created by ph7164 on 30/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

protocol HomeReviewDelegate: class {
    func sendReview(review: String, index: Int)
    func skipReview(index: Int)
}

class HomeReviewCell: UITableViewCell {
    
    weak var delegate : HomeReviewDelegate?
    
    @IBOutlet weak var label_meetingDate: UILabel!
    @IBOutlet weak var button_writeReview: UIButton!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textReviewContainerView: UIView!
    @IBOutlet weak var textview_review: UITextView!
    
    @IBOutlet var button_skip: [UIButton]!
    
    var index: Int!
    
    @IBOutlet weak var writeReviewEndView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func writeReviewBtnPressed(_ sender: Any) {
        textReviewContainerView.isHidden = false
        self.bringSubviewToFront(textReviewContainerView)
    }
    
    
    @IBAction func sendToYamiguBtnPressed(_ sender: Any) {
        writeReviewEndView.isHidden = false
        
        delegate?.sendReview(review: textview_review.text, index: index)
    }
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        writeReviewEndView.isHidden = false
        
        delegate?.skipReview(index: index)
    }
    
}

extension HomeReviewCell: UITextViewDelegate {
    func setupUI() {
        textReviewContainerView.isHidden = true
        writeReviewEndView.isHidden = true
        
        textview_review.delegate = self
        textview_review.textContainerInset = UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13)
        
        for i in 0...1 {
            self.button_skip[i].underline()
        }
    }
    
    override func prepareForReuse() {
        textReviewContainerView.isHidden = true
        writeReviewEndView.isHidden = true
        
        textview_review.delegate = self
        textview_review.textContainerInset = UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13)
        
        for i in 0...1 {
            self.button_skip[i].underline()
        }
    }
    
    func textViewSetupView() {
        if textview_review.text == "불편했던 점이나, 재밌었던 기억을 남겨주세요" {
            textview_review.text = ""
            textview_review.textColor = UIColor(rgb: 0x707070)
        } else if textview_review.text == "" {
            textview_review.text = "불편했던 점이나, 재밌었던 기억을 남겨주세요"
            textview_review.textColor = UIColor(rgb: 0xC6C6C6)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textview_review.text == "" {
            textViewSetupView()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textview_review.resignFirstResponder()
        }
        return true
    }
}
