//
//  HomeVC.swift
//  yamigu
//
//  Created by Yoon on 04/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myMeetingTableView: UITableView!
    @IBOutlet weak var myMeetingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendMeetingCollectionView: UICollectionView!
    
    @IBOutlet weak var todayMeetingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var todayMeetingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupCollectionView()
        
    }
    
    
    
}

extension HomeVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.myMeetingTableView {
            return 1
        } else if tableView == self.todayMeetingTableView {
            
            
            return 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == self.myMeetingTableView {
            if section != 0 {
                return 16.0
            }
            
        } else if tableView == self.todayMeetingTableView {
            if section != 0 {
                return 11.0
            }
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.myMeetingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeMyTableViewCell") as! HomeMyTableViewCell
            
            return cell
        } else if tableView == self.todayMeetingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeExpectedTableViewCell") as! HomeExpectedTableViewCell
            
            cell.contentView.layer.borderColor = UIColor(rgb: 0xE5E5E5).cgColor
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.cornerRadius = 10.0
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeMyTableViewCell") as! HomeMyTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var height = 211.0 * 3 + 16.0 * (3 - 1)
        
        self.myMeetingTableViewHeight.constant = CGFloat(height)
        var height2 = 86.0 * 5 + 11.0 * (5 - 1)
        
        self.todayMeetingTableViewHeight.constant = CGFloat(height2)
        
        height = height + height2
        
        DispatchQueue.main.async {
            self.scrollView.layoutIfNeeded()
            self.myMeetingTableView.layoutIfNeeded()
            self.scrollView.contentSize.height = CGFloat(226.0 + 316.5 + height)
        }
        
        if tableView == self.myMeetingTableView {
            
            return 3
        } else if tableView == self.todayMeetingTableView {
            return 5
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.myMeetingTableView {
            return 211.0
            
        } else if tableView == self.todayMeetingTableView {
            return 86.0
        }
        
        return 0.0
    }
    
    func setupTableView() {
        self.myMeetingTableView.dataSource = self
        self.myMeetingTableView.delegate = self
        
        self.todayMeetingTableView.delegate = self
        self.todayMeetingTableView.dataSource = self
        
        self.myMeetingTableView.register(UINib(nibName: "HomeMyTableViewCell", bundle: nil), forCellReuseIdentifier: "homeMyTableViewCell")
        self.todayMeetingTableView.register(UINib(nibName: "HomeExpectedTableViewCell", bundle: nil), forCellReuseIdentifier: "homeExpectedTableViewCell")
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.contentView.layer.borderColor = UIColor(rgb: 0xE0E0E0).cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.cornerRadius = 10.0
        
        cell.layer.cornerRadius = 10.0
        
        
        return cell
    }
    
    func setupCollectionView() {
        self.recommendMeetingCollectionView.delegate = self
        self.recommendMeetingCollectionView.dataSource = self
        
        self.recommendMeetingCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 291.0, height: 222.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
