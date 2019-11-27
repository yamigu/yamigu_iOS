//
//  ButTicketVC.swift
//  yamigu
//
//  Created by Yoon on 21/10/2019.
//  Copyright © 2019 Yoon. All rights reserved.
//

import UIKit
import StoreKit

class BuyTicketVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        for product in products {
            self.productsArray.append(product)
        }
    }
    
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifier as Set<String>)
            request.delegate = self
            request.start()
        } else {
            var alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplication.openSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.openURL(url! as URL)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var button_ticket_1: UIButton!
    @IBOutlet weak var button_ticket_2: UIButton!
    
    var isButtonPressed = false
    var isButtonPressed2 = false
    
    let productIdentifier = Set(["party.yamigu.www.com.ticket_1", "party.yamigu.www.com.ticket_3"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //requestProductData()
        
        button_ticket_1.setImage(UIImage(named: "image_ticket_1_on"), for: .highlighted)
        button_ticket_2.setImage(UIImage(named: "image_ticket_3_on"), for: .highlighted)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestProductData()
    }
    
    @IBAction func buttonPressed_1(_ sender: Any) {
        /*if isButtonPressed {
            isButtonPressed = false
            
            button_ticket_1.setImage(UIImage(named: "image_ticket_1"), for: .normal)
        } else {
            isButtonPressed = true
            
            button_ticket_1.setImage(UIImage(named: "image_ticket_1_on"), for: .normal)
            
            let payment = SKPayment(product: productsArray[0])
            SKPaymentQueue.default().add(payment)
            
        }*/
        let payment = SKPayment(product: productsArray[0])
                   SKPaymentQueue.default().add(payment)
    }
    @IBAction func buttonPressed_2(_ sender: Any) {
        /*if isButtonPressed2 {
            isButtonPressed2 = false
            
            button_ticket_2.setImage(UIImage(named: "image_ticket_3"), for: .normal)
        } else {
            isButtonPressed2 = true
            
            button_ticket_2.setImage(UIImage(named: "image_ticket_3_on"), for: .normal)
            
            let payment = SKPayment(product: productsArray[1])
            SKPaymentQueue.default().add(payment)
            
        }*/
        let payment = SKPayment(product: productsArray[1])
        SKPaymentQueue.default().add(payment)
    }
    
}
