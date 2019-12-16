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
    
    var blackBackgroundView = UIView()
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            
            SKPaymentQueue.default().restoreCompletedTransactions()
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.blackBackgroundView.removeFromSuperview()
                
                if transaction.payment.productIdentifier == "party.yamigu.www.com.ticket_1" {
                    let json = ["purchase_number":1]
                    self.postRequest("http://106.10.39.154:9999/api/buyticket/", bodyString: "", json: json)
                } else {
                    let json = ["purchase_number":3]
                    self.postRequest("http://106.10.39.154:9999/api/buyticket/", bodyString: "", json: json)
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                self.blackBackgroundView.removeFromSuperview()
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        DispatchQueue.main.async {
            for product in products {
                print("productIdentifier = \(product.productIdentifier)")
                self.productsArray.append(product)
            }
            
            self.blackBackgroundView.removeFromSuperview()
        }
    }
    
    func requestDidFinish(_ request: SKRequest) {
        
    }
    
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            
            request.delegate = self
            request.start()
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
            
            
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
    let request = SKProductsRequest(productIdentifiers: Set(["party.yamigu.www.com.ticket_1", "party.yamigu.www.com.ticket_3"]))
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for transactionPending in SKPaymentQueue.default().transactions {
            SKPaymentQueue.default().finishTransaction(transactionPending)
        }
        button_ticket_1.setImage(UIImage(named: "image_ticket_1_on"), for: .highlighted)
        button_ticket_2.setImage(UIImage(named: "image_ticket_3_on"), for: .highlighted)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestProductData()
        
        self.addLoadingView()
    }
    
    @IBAction func buttonPressed_1(_ sender: Any) {
        
        self.addLoadingView()
        let payment = SKMutablePayment(product: productsArray[0])
        SKPaymentQueue.default().add(payment)
    }
    @IBAction func buttonPressed_2(_ sender: Any) {
        
        self.addLoadingView()
        let payment = SKMutablePayment(product: productsArray[1])
        SKPaymentQueue.default().add(payment)
        //self.addLoadingView()
    }
    
    func addLoadingView() {
        self.blackBackgroundView.frame = self.view.frame
        self.blackBackgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.blackBackgroundView.makeToastActivity(.center)
        self.view.addSubview(blackBackgroundView)
    }
    
    func postRequest(_ urlString: String, bodyString: String, json: [String: Any]){
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(authKey)", forHTTPHeaderField: "Authorization")
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let jsonString = String(data: data, encoding: .utf8) {
            request.httpBody = jsonString.data(using: .utf8)
        }
        
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response{
                
                print(res)
                
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    guard let newValue = json as? Dictionary<String, String> else {
                        print("invalid format")
                        return
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
