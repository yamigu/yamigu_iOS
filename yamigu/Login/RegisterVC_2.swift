//
//  RegisterVC_2.swift
//  yamigu
//
//  Created by Yoon on 10/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class RegisterVC_2: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField_nickName: UITextField!
    @IBOutlet weak var button_collage: UIButton!
    @IBOutlet weak var button_office: UIButton!
    @IBOutlet weak var button_certi: UIButton!
    
    var isCollage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    @IBAction func collageBtnPrssed(_ sender: Any) {
        isCollage = true
        if isCollage {
            self.button_collage.layer.borderColor = UIColor(rgb: 0xFFC850).cgColor
            self.button_collage.setTitleColor(UIColor(rgb: 0xFFC850), for: .normal)
            
            self.button_office.layer.borderColor = UIColor(rgb: 0xC6C6C6).cgColor
            self.button_office.setTitleColor(UIColor(rgb: 0xC6C6C6), for: .normal)
            
            
        }
        
    }
    @IBAction func officeBtnPrssed(_ sender: Any) {
        isCollage = false
        if !isCollage {
            self.button_collage.layer.borderColor = UIColor(rgb: 0xC6C6C6).cgColor
            self.button_collage.setTitleColor(UIColor(rgb: 0xC6C6C6), for: .normal)
            
            self.button_office.layer.borderColor = UIColor(rgb: 0xFFC850).cgColor
            self.button_office.setTitleColor(UIColor(rgb: 0xFFC850), for: .normal)
            
        }
    }
    
    @IBAction func certiBtnPrssed(_ sender: Any) {
        performSegue(withIdentifier: "segue_register3", sender: self)
    }
    
}

extension RegisterVC_2:UITableViewDelegate, UITableViewDataSource {
    
    
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "AgreementTableViewCell", bundle: nil), forCellReuseIdentifier: "agreementTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agreementTableViewCell") as! AgreementTableViewCell
        let images = ["text_agreement1", "text_agreement2", "text_agreement3"]
        
        cell.image_text.image = UIImage(named: images[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.66
    }
    
}
