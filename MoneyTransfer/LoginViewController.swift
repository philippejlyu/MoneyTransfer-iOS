//
//  ViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/24/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Attributes
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: Any) {
        self.login(with: self.usernameTextField.text!, password: self.passwordTextField.text!) { (completed, error) in
            
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        self.createUserAccount(username: self.usernameTextField.text!, password: self.passwordTextField.text!) { (completed, error) in
            print(error)
        }
    }
    
    // MARK: - Helper functions
    func login(with username: String, password: String, completionHandler: @escaping (_ completed: Bool, _ error: String?) -> Void) {
        let url = URL(string: "http://127.0.0.1:5000/login")
        
        let credentialData = "\(username):\(password)"
        let utf8CredentialData = credentialData.data(using: String.Encoding.utf8)!
        let base64Credentials = utf8CredentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if let accessToken = json["token"].string, let expiry = json["expiry"].int {
                print(accessToken)
                print(expiry)
                completionHandler(true, nil)
            }
        }
    }
    
    func createUserAccount(username: String, password: String, completionHandler: @escaping (_ completed: Bool, _ error: String?) -> Void) {
        let url = URL(string: "http://127.0.0.1:5000/createaccount")
        
        let credentialData = "\(username):\(password)"
        let utf8CredentialData = credentialData.data(using: String.Encoding.utf8)!
        let base64Credentials = utf8CredentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if let accessToken = json["token"].string, let expiry = json["expiry"].int {
                print(accessToken)
                print(expiry)
                completionHandler(true, nil)
            } else {
                // There is an error
                let message = json["error"].string!
                completionHandler(false, message)
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to verify your identity"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (result, error) in
                if result {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                    }
                } else {
                    // TODO: Authenticate manually
                }
            }
        } else {
            print("Error authenticating")
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

