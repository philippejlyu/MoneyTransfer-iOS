//
//  KeyTracking.swift
//  MoneyTransfer
//
//  Created by Philippe Yu on 4/28/19.
//  Copyright © 2019 Philippe Yu. All rights reserved.
//

import Foundation

class KeyTracking {
    
    private var keyExpiry = 0
    private var key = ""
    private var username = ""
    
    init() {
        let defaults = UserDefaults.standard
        self.key = defaults.string(forKey: "authenticationKey") ?? ""
        self.keyExpiry = defaults.integer(forKey: "keyExpiry")
        self.username = defaults.string(forKey: "username") ?? ""
    }
    
    func updateKey(_ key: String, expiry: Int, username: String) {
        self.key = key
        self.keyExpiry = expiry
        self.username = username
        let defaults = UserDefaults.standard
        defaults.set(key, forKey: "authenticationKey")
        defaults.set(expiry, forKey: "keyExpiry")
        defaults.set(username, forKey: "username")
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
            return self.key
        }
    }
    
    func getUsername() -> String? {
        if self.isKeyExpired() {
            return nil
        } else {
            return self.username
        }
    }
}
