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
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: Any) {
        ServerInteractor.shared.login(with: self.usernameTextField.text!, password: self.passwordTextField.text!) { (completed, error) in
            if completed {
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            } else {
                let alert = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        ServerInteractor.shared.createUserAccount(username: self.usernameTextField.text!, password: self.passwordTextField.text!) { (completed, error) in
            if completed {
                let alert = UIAlertController(title: "Save password", message: "Would you like to save your password", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    // TODO: Save the password in keychain with biometric authentication
                    
                    
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                })
                let no = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                })
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
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

