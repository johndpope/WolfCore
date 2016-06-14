//
//  DataExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

// Support the Serializable protocol used for caching

extension NSData: Serializable {
    public typealias ValueType = NSData

    public func serialize() -> NSData {
        return self
    }

    public static func deserializeFromData(data: NSData) throws -> NSData {
        return data
    }
}
