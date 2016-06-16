//
//  UTF8.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension String {
    public static func utf8Bytes(from string: String) -> Bytes {
        var bytes = Bytes()
        for c in string.utf8 {
            bytes.append(c)
        }
        return bytes
    }

    public static func utf8Data(from string: String) -> Data {
        return string |> utf8Bytes |> Bytes.data
    }
}

public struct UTF8 {
    public static func string(from utf8Data: Data) throws -> String {
        guard let s = String(data: utf8Data, encoding: .utf8) else {
            throw ValidationError(message: "Invalid UTF-8.", violation: "utf8Format")
        }
        return s
    }
}
