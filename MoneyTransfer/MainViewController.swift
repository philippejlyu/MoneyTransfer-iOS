//
//  MainViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/24/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    
    // MARK: - Properties
    var user = PFUser.current()
    var balance: NSNumber = 0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBalance()
    }
    // MARK: - Actions
    
    // MARK: - Helper functions
    func getBalance() {
        var query = PFQuery(className: "balances")
        query.whereKey("user", equalTo: (user)!)
        do {
            let results = try query.findObjects()
            self.balance = results[0]["balance"] as! NSNumber
            self.balanceLabel.text = "$\(self.balance)"
        } catch let error as Error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
}
