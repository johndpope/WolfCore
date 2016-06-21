//
//  JSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias JSON = JSON1

public struct JSON1 {
    public typealias Value = AnyObject
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]
    public typealias DictionaryOfStrings = [String: String]
    public typealias ArrayOfDictionaries = [Dictionary]

    public static func isNull(_ value: Value) -> Bool {
        return value is NSNull
    }

    public static let null = NSNull()

    public static func encode(_ value: Value) throws -> Data {
        return try JSONSerialization.data(withJSONObject: value, options: [])
    }

    public static func decode(_ data: Data) throws -> Value {
        return try JSONSerialization.jsonObject(with: data, options: [])
    }

    public static func decode(_ string: String) throws -> Value {
        return try string |> UTF8.encode |> decode
    }
}
