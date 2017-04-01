//
//  JSONBuilder.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public class JSONBuilder {
    public var dict = JSON.Dictionary()

    public init() { }

    public func set(_ key: String, to value: JSON.Value?, isNullable: Bool = false) {
        if let value = value {
            dict[key] = value
        } else {
            if isNullable {
                dict[key] = JSON.null
            }
        }
    }

    public func set<T: RawRepresentable>(_ key: String, to value: T?, isNullable: Bool = false) {
        set(key, to: value?.rawValue, isNullable: isNullable)
    }

    public func set<T: JSONModel>(_ key: String, to value: T?, isNullable: Bool = false) {
        set(key, to: value?.json.value, isNullable: isNullable)
    }

    public func set(_ key: String, to value: Date?, isNullable: Bool = false) {
        set(key, to: value?.iso8601, isNullable: isNullable)
    }

    public func set(_ key: String, to value: URL?, isNullable: Bool = false) {
        set(key, to: value?.absoluteString, isNullable: isNullable)
    }
}
