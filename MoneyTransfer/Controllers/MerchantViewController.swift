//
//  MerchantViewController.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 2019-10-30.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import UIKit

class MerchantViewController: UIViewController {
    
    let handler = MoneyInputHandler()
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moneyLabel.text = "0.00"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.moneyLabel.text = self.handler.inputReceived(sender.tag)
    }
    
    @IBAction func pay(_ sender: Any) {
        print(self.handler.getDoubleAmount())
        print(self.handler.getStringAmount())
    }
    

}
