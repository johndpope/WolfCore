//
//  Bytes.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

//import Foundation
//
//public typealias Byte = UInt8
//public typealias Bytes = Array<Byte>
//
//extension Array {
//    public static func data(from bytes: Bytes) -> Data {
//        return Data(bytes: bytes, count: bytes.count)
//    }
//}
//
//extension Data {
//    public var bytes: Bytes {
//        var bytes = Bytes(repeating: 0, count: count)
//        copyBytes(to: &bytes, count: count)
//        return bytes
//    }
//
//    public static func bytes(from data: Data) -> Bytes {
//        return data.bytes
//    }
//}
