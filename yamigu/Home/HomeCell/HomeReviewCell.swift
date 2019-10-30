//
//  HomeReviewCell.swift
//  yamigu
//
//  Created by ph7164 on 30/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import Cosmos

class HomeReviewCell: UITableViewCell {
    
    @IBOutlet weak var label_meetingDate: UILabel!
    @IBOutlet weak var button_writeReview: UIButton!
    
    @IBOutlet weak var ratingsContainerView: UIView!
    @IBOutlet weak var ratingLook: CosmosView!
    @IBOutlet weak var ratingFun: CosmosView!
    @IBOutlet weak var ratingManner: CosmosView!
    
    @IBOutlet weak var textReviewContainerView: UIView!
    @IBOutlet weak var textview_review: UITextView!
    @IBOutlet weak var button_skip: UIButton!
    
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
        ratingsContainerView.isHidden = false
        self.bringSubviewToFront(ratingsContainerView)
    }
    
    
    @IBAction func sendToYamiguBtnPressed(_ sender: Any) {
        writeReviewEndView.isHidden = false
    }
    
    @IBAction func skipBtnPressed(_ sender: Any) {
        writeReviewEndView.isHidden = false
    }
    
}

extension HomeReviewCell: UITextViewDelegate {
    func setupUI() {
        ratingsContainerView.isHidden = true
        textReviewContainerView.isHidden = true
        writeReviewEndView.isHidden = true
        
        button_skip.underline()
        
        textview_review.delegate = self
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
