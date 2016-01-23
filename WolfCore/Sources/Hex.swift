//
//  Hex.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class Hex {
    public static func encode(data: NSData) -> String {
        let bytes = ByteArray.bytesWithData(data)
        var s = String()
        for byte in bytes {
            s += encode(byte)
        }
        return s
    }
    
    public static func encode(bytes: Bytes) -> String {
        return encode(ByteArray.dataWithBytes(bytes))
    }
    
    public static func encode(byte: Byte) -> String {
        return String(byte, radix: 16, uppercase: false).paddedToCount(2, withCharacter: "0")
    }
    
    public static func decode(string: String) throws -> Int {
        if let i = Int(string, radix: 16) {
            return i
        } else {
            throw GeneralError(message: "Invalid hex string: \(string).")
        }
    }
}
