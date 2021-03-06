//
//  ByteArray.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias Byte = UInt8
public typealias Bytes = [Byte]

public class ByteArray {
    public static func bytes(withData data: NSData) -> Bytes {
        var bytes = Bytes(count: data.length, repeatedValue: 0)
        data.getBytes(&bytes, length: data.length)
        return bytes
    }

    public static func data(withBytes byteArray: Bytes) -> NSData {
        return NSData(bytes: byteArray, length: byteArray.count)
    }
}
