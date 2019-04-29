//
//  KeyTracking.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/28/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import Foundation

class KeyTracking {
    
    var keyExpiry = 0
    var key = ""
    
    init() {
        let defaults = UserDefaults.standard
        self.key = defaults.string(forKey: "authenticationKey") ?? ""
        self.keyExpiry = defaults.integer(forKey: "keyExpiry")
    }
    
    func updateKey(_ key: String, expiry: Int) {
        self.key = key
        self.keyExpiry = expiry
        let defaults = UserDefaults.standard
        defaults.set(key, forKey: "authenticationKey")
        defaults.set(expiry, forKey: "keyExpiry")
    }
    
    func isKeyExpired() -> Bool {
        let timeInterval = Date().timeIntervalSince1970
        return keyExpiry < Int(timeInterval)
    }
    
    func getKey() -> String? {
        // Returns nil if the key is expired
        if self.isKeyExpired() {
            return nil
        } else {
            return key
        }
    }
}
