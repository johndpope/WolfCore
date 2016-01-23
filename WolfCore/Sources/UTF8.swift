//
//  UTF8.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class UTF8 {
    public static func encode(string: String) -> Bytes {
        var bytes = Bytes()
        for c in string.utf8 {
            bytes.append(c)
        }
        return bytes
    }
    
    public static func encode(string: String) -> NSData {
        return ByteArray.dataWithBytes(encode(string))
    }
    
    public static func decode(data: NSData) throws -> String {
        if let s = String(data: data, encoding: NSUTF8StringEncoding) {
            return s
        } else {
            throw GeneralError(message: "Invalid UTF-8.")
        }
    }
    
    public static func decode(bytes: Bytes) throws -> String {
        return try decode(ByteArray.dataWithBytes(bytes))
    }
}
