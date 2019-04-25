//
//  ViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/24/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import Parse
import LocalAuthentication

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
        print(PFUser.current() != nil)
        if PFUser.current() != nil {
            // We are logged in, we will now verify the identity
            self.usernameTextField.text = (PFUser.current()?.email)!
            self.authenticate()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loggedIn", sender: user)
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        var user = PFUser()
        user.username = self.usernameTextField.text
        user.password = self.passwordTextField.text
        user.email = self.usernameTextField.text
        // Now we sign them up
        user.signUpInBackground { (succeeded, error) in
            if !succeeded {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                // Now we create a balance for the user
                self.createUserBalance()
                self.performSegue(withIdentifier: "loggedIn", sender: user)
            }
        }
    }
    
    // MARK: - Helper functions
    
    func createUserBalance() {
        // TODO: Change this to access the REST api that will handle any balance changes
        var parseObject = PFObject(className:"balances")
        parseObject["user"] = PFUser.current()
        parseObject["balance"] = 0
        
        // Saves the new object.
        parseObject.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // The object has been saved.
                print("success")
            } else {
                print(error?.localizedDescription)
                // There was a problem, check error.description
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

