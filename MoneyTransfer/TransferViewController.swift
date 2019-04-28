//
//  TransferViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/25/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import Parse

class TransferViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    // MARK: - Properties
    var recipient: PFUser? = nil
    var amount = 0.0
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func send() {
        // TODO: Send
        if let recipient = self.recipient {
            var transfer = PFObject(className: "moneyTransfers")
            
            transfer["amount"] = self.amount
            transfer["from"] = (PFUser.current())!
            transfer["to"] = (PFUser.current())!
            
            transfer.saveInBackground { (completed, error) in
                if completed {
                    // TODO: Contact REST API to have the sender balance decreased and receiver balance increase
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "You must select someone to send money to", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
