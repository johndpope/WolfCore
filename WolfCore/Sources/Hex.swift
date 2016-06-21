//
//  Hex.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class Hex {
    public static func encode(_ data: Data) -> String {
        var s = String()
        for byte in data {
            s += encode(byte)
        }
        return s
    }

    public static func encode(_ byte: Byte) -> String {
        return String(byte, radix: 16, uppercase: false) |> String.padded(toCount: 2, withCharacter: "0")
    }

    public static func decode(_ string: String) throws -> Int {
        if let i = Int(string, radix: 16) {
            return i
        } else {
            throw ValidationError(message: "Invalid hex string: \(string).", violation: "hexFormat")
        }
    }
}
