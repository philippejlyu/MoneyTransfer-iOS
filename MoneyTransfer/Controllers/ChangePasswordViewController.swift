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
            ServerInteractor.shared.changePassword(old: oldPassword.text!, new: newPassword.text!) { (completed, error) in
                if completed {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(title: "Error", message: error!)
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
