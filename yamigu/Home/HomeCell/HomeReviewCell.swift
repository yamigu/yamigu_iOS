//
//  HomeReviewCell.swift
//  yamigu
//
//  Created by ph7164 on 30/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import Cosmos

protocol HomeReviewDelegate: class {
    func sendReview()
    func sendRatings()
}

class HomeReviewCell: UITableViewCell {
    
    weak var delegate : HomeReviewDelegate?
    
    @IBOutlet weak var label_meetingDate: UILabel!
    @IBOutlet weak var button_writeReview: UIButton!
    
    @IBOutlet weak var ratingsContainerView: UIView!
    @IBOutlet weak var ratingLook: CosmosView!
    @IBOutlet weak var ratingFun: CosmosView!
    @IBOutlet weak var ratingManner: CosmosView!
    
    @IBOutlet weak var textReviewContainerView: UIView!
    @IBOutlet weak var textview_review: UITextView!
    @IBOutlet weak var button_skip: UIButton!
    
    var ratedLook = 0.0
    var ratedFun = 0.0
    var ratedManner = 0.0
    
    @IBOutlet weak var writeReviewEndView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
        
        ratingLook.didTouchCosmos = { rating in
            self.ratedLook = rating
            print("ratedLook: \(self.ratedLook)")
        }
        
        ratingFun.didTouchCosmos = { rating in
            self.ratedFun = rating
            print("ratedFun: \(self.ratedFun)")
        }
        
        ratingManner.didTouchCosmos = { rating in
            self.ratedManner = rating
            print("ratedManner: \(self.ratedManner)")
        }
        
        ratingLook.didFinishTouchingCosmos = { rating in
            self.checkRatingDone()
        }
        
        ratingFun.didFinishTouchingCosmos = { rating in
            self.checkRatingDone()
        }
        
        ratingManner.didFinishTouchingCosmos = { rating in
            self.checkRatingDone()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkRatingDone() {
        if ratedLook != 0.0 && ratedFun != 0.0 && ratedManner != 0.0 {
            textReviewContainerView.isHidden = false
            self.bringSubviewToFront(textReviewContainerView)
            
            delegate?.sendRatings()
        }
    }
    
    @IBAction func writeReviewBtnPressed(_ sender: Any) {
        ratingsContainerView.isHidden = false
        self.bringSubviewToFront(ratingsContainerView)
    }
    
    
    @IBAction func sendToYamiguBtnPressed(_ sender: Any) {
        writeReviewEndView.isHidden = false
        
        delegate?.sendReview()
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
        
        textview_review.delegate = self
        textview_review.textContainerInset = UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13)
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
