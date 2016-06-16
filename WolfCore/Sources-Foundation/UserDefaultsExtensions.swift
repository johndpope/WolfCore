//
//  UserDefaultsExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/13/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public let userDefaults = UserDefaults.standard()
public let userDefaultsLogGroup = "UserDefaults"

extension UserDefaults {
    public subscript(key: String) -> AnyObject? {
        get {
            let value = userDefaults.object(forKey: key)
            logTrace("get key: \(key), value: \(value)", group: userDefaultsLogGroup)
            return value
        }
        set {
            logTrace("set key: \(key), newValue: \(newValue)", group: userDefaultsLogGroup)
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
            userDefaults.synchronize()
        }
    }
}
