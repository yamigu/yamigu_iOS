//
//  MatchVC.swift
//  yamigu
//
//  Created by Yoon on 21/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit

class MatchVC: UIViewController, UINavigationBarDelegate {
    @IBOutlet weak var button_receive: UIButton!
    @IBOutlet weak var button_request: UIButton!
    
    @IBOutlet weak var label_count: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button_left: UIButton!
    @IBOutlet weak var button_right: UIButton!
    
    var matchingDict : Dictionary<String, Any>!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "MatchCell", bundle: nil), forCellWithReuseIdentifier: "matchCell")
    }
    
}

extension MatchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCell", for: indexPath) as! MatchCell
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 315.0, height: 222.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11.0
    }
}
