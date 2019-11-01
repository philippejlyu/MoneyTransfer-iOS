//
//  ServerInteractor.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 2019-10-31.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ServerInteractor {
    
    public static var shared = ServerInteractor()
    private let apiURL = "https://2b4fed94.ngrok.io"//"http://127.0.0.1:5000"
    
    // MARK: Login and account creation
    func login(with username: String, password: String, completionHandler: @escaping (_ completed: Bool, _ error: String?) -> Void) {
        let url = URL(string: "\(self.apiURL)/login")
        
        let credentialData = "\(username):\(password)"
        let utf8CredentialData = credentialData.data(using: String.Encoding.utf8)!
        let base64Credentials = utf8CredentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let accessToken = json["token"].string, let expiry = json["expiry"].int {
                    let tracking = KeyTracking()
                    tracking.updateKey(accessToken, expiry: expiry, username: username)
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, "Invalid username or password")
                }
            } else {
                completionHandler(false, "Could not connect to the server")
            }
            
        }
    }
    
    func createUserAccount(username: String, password: String, completionHandler: @escaping (_ completed: Bool, _ error: String?) -> Void) {
        let url = URL(string: "\(self.apiURL)/createaccount")
        
        let credentialData = "\(username):\(password)"
        let utf8CredentialData = credentialData.data(using: String.Encoding.utf8)!
        let base64Credentials = utf8CredentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let accessToken = json["token"].string, let expiry = json["expiry"].int {
                    let tracking = KeyTracking()
                    tracking.updateKey(accessToken, expiry: expiry, username: username)
                    completionHandler(true, nil)
                } else {
                    // There is an error
                    let message = json["error"].string!
                    completionHandler(false, message)
                }
            } else {
                completionHandler(false, "Could not connect to the server")
            }
        }
    }
    
    func changePassword(old: String, new: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let url = URL(string: "\(self.apiURL)/changePassword")
        let keyTracking = KeyTracking()
        let username = keyTracking.getUsername()!
        let token = keyTracking.getKey()!
        let credentialData = "\(username):\(old)"
        let utf8CredentialData = credentialData.data(using: String.Encoding.utf8)!
        let base64Credentials = utf8CredentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)", "token": token, "new_password": new]
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let status = json["success"].string {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, "Your password is incorrect")
                }
            } else {
                completionHandler(false, "Your password is incorrect")
            }
        }
    }
    
    func activateCard(card: String, completionHandler: @escaping (_ completed: Bool) -> Void) {
        let keyTracking = KeyTracking()
        let url = URL(string: "\(self.apiURL)/addCard")
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
    
    
    // MARK: - Gathering user data
    
    func getBalance(completionHandler: @escaping (_ balance: Double?, _ error: String?) -> Void) {
        let keyTracking = KeyTracking()
        let url = URL(string: "\(self.apiURL)/balance")
        var headers: HTTPHeaders = [:]
        if let key = keyTracking.getKey(), let username = keyTracking.getUsername() {
            headers = ["token": key, "username": username]
        } else {
            // TODO: Session expired
        }
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let balance = json["balance"].double {
                    completionHandler(balance, nil)
                }
            } else {
                completionHandler(nil, "Could not connect to the server")
            }
        }
    }
    
    func getTransactionData(completionHandler: @escaping (_ incoming: Array<JSON>?, _ outgoing: Array<JSON>?, _ error: String?) -> Void) {
        let url = URL(string: "\(self.apiURL)/transactions")
        var headers: HTTPHeaders = [:]
        let tracking = KeyTracking()
        if let token = tracking.getKey(), let username = tracking.getUsername() {
            headers = ["token": token, "username": username]
            
            Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    if let outgoing = json["outgoing"].array, let incoming = json["incoming"].array {
                        // TODO: Make incoming and outgoing transactions separate classes
                        completionHandler(incoming, outgoing, nil)
                        
                    }
                } else {
                    completionHandler(nil, nil, "Connection error")
                }
            }
        } else {
            completionHandler(nil, nil, "Session Expired")
        }
    }
    
    // MARK: - Money Transfering
    func transferMoney(recipient: String, amount: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let keyTracking = KeyTracking()
        let url = URL(string: "\(self.apiURL)/transfer")
        var header: HTTPHeaders = [:]
        if let token = keyTracking.getKey(), let username = keyTracking.getUsername() {
            header = ["token": token,
                      "username": username,
                      "recipient": recipient,
                      "amount": amount]
        }
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON(completionHandler: { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let _ = json["success"].string {
                    completionHandler(true, nil)
                } else {
                    let error = json["error"].string!
                    completionHandler(false, error)
                    
                }
            } else {
                completionHandler(false, "Could not connect to the server")
            }
        })
    }
    
    func sendTransaction(card: String, amount: String, completionHandler: @escaping (_ completed: Bool, _ error: String?) -> Void) {
        let keyTracking = KeyTracking()
        let url = URL(string: "\(self.apiURL)/chargeCard")
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
                    completionHandler(true, nil)
                } else {
                    if let error = json["error"].string {
                        completionHandler(false, error)
                    } else {
                        completionHandler(false, "Card declined")
                    }
                }
            }
        }
    }
    
}
