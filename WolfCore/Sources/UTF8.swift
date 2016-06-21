//
//  UTF8.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct UTF8 {
    public static func encode(_ string: String) -> Data {
        return Data(bytes: Array(string.utf8))
    }

    public static func decode(_ data: Data) throws -> String {
        guard let s = String(data: data, encoding: .utf8) else {
            throw ValidationError(message: "Invalid UTF-8.", violation: "utf8Format")
        }
        return s
    }
}
