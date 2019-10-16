//
//  LoginCheckVC.swift
//  yamigu
//
//  Created by Yoon on 16/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import KakaoCommon

class LoginCheckVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        /*KOSession.shared()?.logoutAndClose(completionHandler: { (success, error) in
            if success {
                
            } else {
                
            }
        })
        */
        
        
        
        print("access token = \(KOSession.shared()?.token?.accessToken)")
        if KOSession.shared()?.token?.accessToken != nil {
            
        } else {
            performSegue(withIdentifier: "segue_onboarding", sender: self)
        }
    }

}
