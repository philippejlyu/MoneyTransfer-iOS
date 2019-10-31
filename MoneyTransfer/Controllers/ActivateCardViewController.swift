//
//  ActivateCardViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 2019-10-31.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import CoreNFC
import Alamofire
import SwiftyJSON

class ActivateCardViewController: UIViewController {

    var readerSession: NFCTagReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func activateButtonPressed() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("Reading not available")
            return
        }
        self.readerSession = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        self.readerSession?.alertMessage = "Activate card"
        self.readerSession?.begin()
    }
    

}

extension ActivateCardViewController: NFCTagReaderSessionDelegate {
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
            self.activateCard(card: mifareTag.identifier.base64EncodedString()) { (completed) in
                if completed {
                    session.invalidate()
                } else {
                    session.invalidate(errorMessage: "Error activating the card")
                }
            }
        }
    }
    
    func activateCard(card: String, completionHandler: @escaping (_ completed: Bool) -> Void) {
        let keyTracking = KeyTracking()
        let url = URL(string: "http://127.0.0.1:5000/addCard")
        var header: HTTPHeaders = [:]
        if let token = keyTracking.getKey(), let username = keyTracking.getUsername() {
            header = ["token": token,
                      "username": username,
                      "card": card]
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
