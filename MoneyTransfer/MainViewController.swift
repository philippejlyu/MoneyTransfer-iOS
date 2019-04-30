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
        self.getBalance()
    }
    // MARK: - Actions
    
    // MARK: - Helper functions
    func getBalance() {
        let keyTracking = KeyTracking()
        let url = URL(string: "http://127.0.0.1:5000/balance")
        var headers: HTTPHeaders = [:]
        if let key = keyTracking.getKey(), let username = keyTracking.getUsername() {
            headers = ["token": key, "username": username]
        } else {
            // TODO: Session expired
        }
        
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let responseValue = response.result.value {
                let json = JSON(responseValue)
                if let balance = json["balance"].double {
                    self.balance = balance
                    self.balanceLabel.text = "$\(self.balance)"
                }
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
