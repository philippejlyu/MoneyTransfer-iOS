//
//  MoneyInputHandler.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 2019-10-30.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import Foundation

class MoneyInputHandler {
    private var amount = ""
    private var decimalPressed = false
    private var numDecimals = 0
    
    /**
     Adds the input when it is received to the amount string, then returns the new string
     */
    func inputReceived(_ input: Int) -> String {
        switch input {
        case 10:
            if !decimalPressed {
                self.decimalPressed = true
                amount += "."
            }
        case 11:
            delete()
        default:
            if decimalPressed {
                if numDecimals < 2 {
                    numDecimals += 1
                    amount += "\(input)"
                }
            } else {
                amount += "\(input)"
            }
        }
        
        return self.amount
    }
    
    /**
     Handles deletion of numbers from the number
     */
    private func delete() {
        let last = amount.suffix(1)
        if decimalPressed {
            if last == "." {
                decimalPressed = false
            } else {
                numDecimals -= 1
            }
        }
        if amount.count > 0 {
            amount.removeLast()
        }
    }
    
    func getStringAmount() -> String {
        return self.amount
    }
    
    func getDoubleAmount() -> Double {
        return Double(amount) as! Double
    }
    
    func reset() {
        self.decimalPressed = false
        self.amount = ""
        self.numDecimals = 0
    }
    
    
}
