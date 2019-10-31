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
        
            ServerInteractor.shared.sendTransaction(card: mifareTag.identifier.base64EncodedString(), amount: self.amount) { (completed) in
                if completed {
                    session.invalidate()
                } else {
                    session.invalidate(errorMessage: "Card declined")
                }
            }
        
        }
    }
    
}
