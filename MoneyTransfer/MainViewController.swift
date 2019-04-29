//
//  MainViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/24/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    
    // MARK: - Properties
    var balance: NSNumber = 0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBalance()
    }
    // MARK: - Actions
    
    // MARK: - Helper functions
    func getBalance() {
        
    }
    
    // MARK: - Navigation
}
