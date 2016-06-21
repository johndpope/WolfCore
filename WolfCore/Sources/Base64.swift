//
//  Base64.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct Base64 {
    public static func encode(_ data: Data) -> String {
        return data.base64EncodedString()
    }

    public static func decode(_ string: String) throws -> Data {
        if let data = Data(base64Encoded: string) {
            return data
        } else {
            throw ValidationError(message: "Invalid base64 string.", violation: "base64Format")
        }
    }
}
