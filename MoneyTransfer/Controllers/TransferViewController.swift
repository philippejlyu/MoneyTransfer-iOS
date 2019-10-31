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
        ServerInteractor.shared.transferMoney(recipient: recipientTextField.text!, amount: amountTextField.text!) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
