//
//  TransferViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/25/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransferViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var recipientTextField: UITextField!
    // MARK: - Properties
    var amount = 0.0
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func send() {
        self.userExists(username: self.recipientTextField.text!) { (exists) in
            if exists {
                let keyTracking = KeyTracking()
                let url = URL(string: "http://127.0.0.1:5000/transfer")
                var header: HTTPHeaders = [:]
                if let token = keyTracking.getKey(), let username = keyTracking.getUsername() {
                    header = ["token": token,
                              "username": username,
                              "recipient": self.recipientTextField.text!,
                              "amount": self.amountTextField.text!]
                }
                Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON(completionHandler: { (response) in
                    if let responseValue = response.result.value {
                        let json = JSON(responseValue)
                        if let _ = json["success"].string {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            let error = json["error"].string!
                            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Could not connect to the server", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                let alert = UIAlertController(title: "Recipient does not exist", message: "The recipient of this transfer does not exist", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper functions
    func userExists(username: String, completionHandler: @escaping (_ exists: Bool) -> Void) {
        let url = URL(string: "http://127.0.0.1:5000/canreceivemoney")
        let header: HTTPHeaders = ["username": recipientTextField.text!]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let exists = json["userExists"].bool {
                    completionHandler(exists)
                } else {
                    completionHandler(false)
                }
            } else {
                completionHandler(false)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
