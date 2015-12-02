//
//  UserDefaultsExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/13/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public let userDefaults = NSUserDefaults.standardUserDefaults()

extension NSUserDefaults {
    public subscript(key: String) -> AnyObject? {
        get {
            return userDefaults.objectForKey(key)
        }
        set {
            if let newValue = newValue {
                userDefaults.setObject(newValue, forKey: key)
            } else {
                userDefaults.removeObjectForKey(key)
            }
            userDefaults.synchronize()
        }
    }
}
