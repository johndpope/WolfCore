//
//  Hex.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class Hex {
    public static func encode(data: NSData) -> String {
        let bytes = ByteArray.bytes(withData: data)
        var s = String()
        for byte in bytes {
            s += encode(byte)
        }
        return s
    }

    public static func encode(bytes: Bytes) -> String {
        return encode(ByteArray.data(withBytes: bytes))
    }

    public static func encode(byte: Byte) -> String {
        return String(byte, radix: 16, uppercase: false).padded(toCount: 2, withCharacter: "0")
    }

    public static func decode(string: String) throws -> Int {
        if let i = Int(string, radix: 16) {
            return i
        } else {
            throw ValidationError(message: "Invalid hex string: \(string).", identifier: "hexFormat")
        }
    }
}
