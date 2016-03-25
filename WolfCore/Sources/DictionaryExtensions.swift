//
//  DictionaryExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 1/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

extension Dictionary {
    mutating func update(fromDictionary dict: Dictionary) {
        for (key, value) in dict {
            self.updateValue(value, forKey: key)
        }
    }
}
