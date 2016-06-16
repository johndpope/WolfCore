//
//  Base64.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct Base64 {
    public static func data(from base64String: String) throws -> Data {
        if let data = Data(base64Encoded: base64String) {
            return data
        } else {
            throw ValidationError(message: "Invalid base64 string.", violation: "base64Format")
        }
    }
}

extension Data {
    public var base64: String {
        return base64EncodedString()
    }

    public static func base64(from data: Data) -> String {
        return data.base64
    }
}
