//
//  ButTicketVC.swift
//  yamigu
//
//  Created by Yoon on 21/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class BuyTicketVC: UIViewController {

    @IBOutlet weak var button_ticket_1: UIButton!
    @IBOutlet weak var button_ticket_2: UIButton!
    
    var isButtonPressed = false
    var isButtonPressed2 = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonPressed_1(_ sender: Any) {
        if isButtonPressed {
            isButtonPressed = false
            
            button_ticket_1.setImage(UIImage(named: "image_ticket_1"), for: .normal)
        } else {
            isButtonPressed = true
            
            button_ticket_1.setImage(UIImage(named: "image_ticket_1_on"), for: .normal)
            
        }
    }
    @IBAction func buttonPressed_2(_ sender: Any) {
        if isButtonPressed2 {
            isButtonPressed2 = false
            
            button_ticket_2.setImage(UIImage(named: "image_ticket_2"), for: .normal)
        } else {
            isButtonPressed2 = true
            
            button_ticket_2.setImage(UIImage(named: "image_ticket_2_on"), for: .normal)
            
        }
    }
    
}
