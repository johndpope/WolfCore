//
//  Serializable.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public protocol Serializable {
    associatedtype ValueType

    func serialize() -> NSData
    static func deserializeFromData(data: NSData) throws -> ValueType
}
