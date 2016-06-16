//
//  Hex.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension Array {
    public static func hex(from bytes: Bytes) -> String {
        var s = String()
        for byte in bytes {
            s += Hex.string(from: byte)
        }
        return s
    }
}

extension Data {
    public static func hex(from data: Data) -> String {
        return data |> Data.bytes |> Bytes.hex
    }
}

public class Hex {
    public static func string(from byte: Byte) -> String {
        return String(byte, radix: 16, uppercase: false) |> String.padded(toCount: 2, withCharacter: "0")
    }

    public static func int(from hexString: String) throws -> Int {
        if let i = Int(hexString, radix: 16) {
            return i
        } else {
            throw ValidationError(message: "Invalid hex string: \(hexString).", violation: "hexFormat")
        }
    }
}
