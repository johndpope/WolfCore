//
//  Base64.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding data as Base-64 encoded strings.
///
/// For more information: [Base64 on Wikipedia](https://en.wikipedia.org/wiki/Base64)
public struct Base64: RawRepresentable {
    public enum Error: ErrorProtocol {
        case invalid
    }

    public let rawValue: String

    public init?(rawValue: String) {
        self.init(string: rawValue)
    }

    public init(string: String) {
        self.rawValue = string
    }

    public init(data: Data) {
        rawValue = data.base64EncodedString()
    }

    public func data() throws -> Data {
        if let data = Data(base64Encoded: rawValue) {
            return data
        } else {
            throw Error.invalid
        }
    }

    public func string() -> String {
        return rawValue
    }
}
