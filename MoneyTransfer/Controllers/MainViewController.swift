//
//  MainViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/24/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    
    // MARK: - Properties
    var balance = 0.0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBalance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateBalance()
    }
    // MARK: - Actions
    
    // MARK: - Helper functions
    func updateBalance() {
        ServerInteractor.shared.getBalance { (balance, error) in
            if let balance = balance {
                self.balance = balance
                let balanceText = String(format: "%.2f", self.balance)
                self.balanceLabel.text = balanceText
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not connect to the server", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
}
