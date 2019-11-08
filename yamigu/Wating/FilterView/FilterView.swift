//
//  FilterView.swift
//  yamigu
//
//  Created by 윤종서 on 2019/10/05.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import MultiSlider

protocol FilterViewDelegate: class {
    func typeBtnPressed(index : Int)
    func plceBtnPressed(index : Int)
    
    func typeBtnDeSelected(index : Int)
    func placeBtnDeSelected(index : Int)
    
    func slideValueChanged(value : [CGFloat])
    
    func filterClearAll()
    func filterComp()
}

class FilterView: UIView {
    weak var delegate: FilterViewDelegate?
    @IBOutlet var button_types: [UIButton]!
    @IBOutlet weak var compBtn: UIButton!
    
    @IBOutlet var button_places: [UIButton]!
    
    //@IBOutlet weak var slider: MultiSlider!

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var slider: MultiSlider!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func setupFilterView() {
        self.commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        slider.valueLabelPosition = .bottom
        slider.isValueLabelRelative = false
        
        slider.value = [20, 30]
        
        slider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderChanged(slider:)), for: . touchUpInside)
        
        self.buttonSetUp()
    }
    
    func buttonSetUp() {
        for btn in button_types {
            btn.tintColor = .clear
            btn.backgroundColor = UIColor(rgb: 0xC6C6C6)
            
        }
        
        for btn in button_places {
            btn.tintColor = .clear
            btn.backgroundColor = UIColor(rgb: 0xC6C6C6)
            
        }
    }
    
    @objc func sliderChanged(slider: MultiSlider) {
        print("\(slider.value)") // e.g., [1.0, 4.5, 5.0]
        
        delegate?.slideValueChanged(value: slider.value)
    }
    

    @IBAction func typeBtnPressed(_ sender: Any) {
        let btn = sender as! UIButton
        
        if btn.isSelected {
            btn.isSelected = false
            btn.backgroundColor = UIColor(rgb: 0xC6C6C6)
            
            delegate?.typeBtnDeSelected(index: btn.tag)
        } else {
            btn.isSelected = true
            btn.backgroundColor = UIColor(rgb: 0xFF7B22)
            
            delegate?.typeBtnPressed(index: btn.tag)
        }
    }
    @IBAction func placeBtnPressed(_ sender: Any) {
        let btn = sender as! UIButton
        
        if btn.isSelected {
            btn.isSelected = false
            btn.backgroundColor = UIColor(rgb: 0xC6C6C6)
            
            delegate?.placeBtnDeSelected(index: btn.tag)
        } else {
            btn.isSelected = true
            btn.backgroundColor = UIColor(rgb: 0xFF7B22)
            
            delegate?.plceBtnPressed(index: btn.tag)
        }
    }
    @IBAction func compBtnPressed(_ sender: Any) {
        delegate?.filterComp()
    }
    @IBAction func cealerBtnPressed(_ sender: Any) {
        delegate?.filterClearAll()
    }
}
