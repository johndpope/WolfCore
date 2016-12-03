//
//  DataExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

// Support the Serializable protocol used for caching

extension Data: Serializable {
    public typealias ValueType = Data

    public func serialize() -> Data {
        return self
    }

    public static func deserializeFromData(data: Data) throws -> Data {
        return data
    }

    public init(bytes: MutableRandomAccessSlice<Data>) {
        self.init(bytes: Array(bytes))
    }

    public init(_ data: Data) {
        let p: UnsafePointer<UInt8> = data.withUnsafeBytes { $0 }
        self.init(bytes: p, count: data.count)
    }
}
