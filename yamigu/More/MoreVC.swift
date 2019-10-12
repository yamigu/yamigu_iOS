//
//  MoreVC.swift
//  yamigu
//
//  Created by Yoon on 06/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let images = ["image_more_cell1", "image_more_cell2", "image_more_cell3", "image_more_cell4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
}

extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: self.images[indexPath.section])
        
        return cell
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        return 11.7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: "segue_place", sender: self)
        } else if indexPath.section == 2 {
                   
        } else if indexPath.section == 3 {
                   
        }
    }
}
