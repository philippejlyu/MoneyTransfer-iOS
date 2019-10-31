//
//  MerchantViewController+NFCTagReaderSessionDelegate.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 2019-10-30.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import CoreNFC
import Alamofire
import SwiftyJSON

extension MerchantViewController: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if tags.count > 1 {
            session.invalidate(errorMessage: "Error, found more than one card")
        }
        
        session.connect(to: tags.first!) { (error) in
            if error != nil {
                print("Error reading the tag")
            }
        
            var mifareTag: NFCMiFareTag
            switch tags.first! {
            case let .miFare(tag):
                mifareTag = tag
            default:
                return
            }
        
            self.sendTransaction(card: mifareTag.identifier.base64EncodedString(), amount: "4.40") { (completed) in
                if completed {
                    session.invalidate()
                } else {
                    session.invalidate(errorMessage: "Card declined")
                }
            }
        
        }
    }
    
    func sendTransaction(card: String, amount: String, completionHandler: @escaping (_ completed: Bool) -> Void) {
        let keyTracking = KeyTracking()
        let url = URL(string: "http://127.0.0.1:5000/chargeCard")
        var header: HTTPHeaders = [:]
        if let token = keyTracking.getKey(), let username = keyTracking.getUsername() {
            header = ["token": token,
                      "username": username,
                      "card": card,
                      "amount": amount]
        }
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let _ = json["success"].string {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
}
