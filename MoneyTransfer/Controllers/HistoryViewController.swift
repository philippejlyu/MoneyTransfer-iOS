//
//  HistoryViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/25/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UITableViewController {

    // MARK: - Properties
    var incomingTransactions: Array<JSON>?
    var outgoingTransactions: Array<JSON>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return incomingTransactions?.count ?? 0
        } else {
            return outgoingTransactions?.count ?? 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Incoming Transactions"
        } else {
            return "Outgoing Transactions"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        if indexPath.section == 0 {
            let reference = incomingTransactions![indexPath.row]
            cell.recipientNameLabel.text = reference[0].string!
            let amount = String(format: "%.2f", reference[2].double!)
            cell.amountLabel.text = amount
        } else {
            let reference = outgoingTransactions![indexPath.row]
            cell.recipientNameLabel.text = "\(reference[1].string!)"
            let balanceText = String(format: "%.2f", reference[2].double!)
            cell.amountLabel.text = balanceText
            if reference[4].int! == 1 {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Helper functions
    func refreshData() {
        ServerInteractor.shared.getTransactionData { (incoming, outgoing, error) in
            if let incoming = incoming, let outgoing = outgoing {
                self.incomingTransactions = incoming
                self.outgoingTransactions = outgoing
                self.tableView.reloadData()
            }
        }
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
