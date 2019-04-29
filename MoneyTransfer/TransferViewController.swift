//
//  TransferViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/25/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit

class TransferViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    // MARK: - Properties
    var amount = 0.0
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func send() {
        
        
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
