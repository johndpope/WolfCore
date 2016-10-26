//
//  JSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias JSON = FoundationJSON

public struct FoundationJSON {
    public typealias Value = Any
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]
    public typealias DictionaryOfStrings = [String: String]
    public typealias ArrayOfDictionaries = [Dictionary]

    public let value: Value
    public let data: Data

    public var string: String {
        return try! data |> UTF8.init |> String.init
    }

    public init(value: Value) throws {
        data = try JSONSerialization.data(withJSONObject: value)
        self.value = value
    }

    public init(data: Data) throws {
        value = try JSONSerialization.jsonObject(with: data)
        self.data = data
    }

    public init(string: String) throws {
        try self.init(data: string |> UTF8.init |> Data.init)
    }

    public static func isNull(_ value: Value) -> Bool {
        return value is NSNull
    }

    public static let null = NSNull()
}
