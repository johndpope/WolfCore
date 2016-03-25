//
//  Base64.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class Base64 {
    public static func encode(data: NSData) -> String {
        return data.base64EncodedStringWithOptions([])
    }

    public static func encode(bytes: Bytes) -> String {
        return encode(ByteArray.data(withBytes: bytes))
    }

    public static func decode(string: String) throws -> NSData {
        if let data = NSData(base64EncodedString: string, options: [.IgnoreUnknownCharacters]) {
            return data
        } else {
            throw ValidationError(message: "Invalid base64 string.")
        }
    }

    public static func decode(string: String) throws -> Bytes {
        return ByteArray.bytes(withData: try decode(string))
    }
}
