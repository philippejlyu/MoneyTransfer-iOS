//
//  ViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/24/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Attributes
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let loggedIn = defaults.bool(forKey: "loggedIn")
        
        if loggedIn {
            // Ask for touch id
        } else {
            // Login for the first time
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

