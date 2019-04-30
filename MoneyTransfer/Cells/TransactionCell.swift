//
//  TransactionCell.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/29/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
