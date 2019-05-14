//
//  ChangePasswordViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 5/5/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ChangePasswordViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func done() {
        if newPassword.text == confirmPassword.text {
            let url = URL(string: "http://127.0.0.1:5000/changePassword")
            let keyTracking = KeyTracking()
            let username = keyTracking.getUsername()!
            let token = keyTracking.getKey()!
            let credentialData = "\(username):\(oldPassword.text!)"
            let utf8CredentialData = credentialData.data(using: String.Encoding.utf8)!
            let base64Credentials = utf8CredentialData.base64EncodedString(options: [])
            let headers = ["Authorization": "Basic \(base64Credentials)", "token": token, "new_password": newPassword.text!]
            
            Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    if let status = json["success"].string {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.showAlert(title: "Error", message: "Your password is incorrect")
                    }
                } else {
                    self.showAlert(title: "Error", message: "Your password is incorrect")
                }
                
            }
        } else {
            self.showAlert(title: "Error", message: "Your passwords do not match")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
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
