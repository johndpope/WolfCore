//
//  JSON.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias JSON = FoundationJSON

public struct FoundationJSON {
    public typealias Value = Any
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]
    public typealias DictionaryOfStrings = [String: String]
    public typealias ArrayOfStrings = [String]
    public typealias ArrayOfDictionaries = [Dictionary]

    public let value: Value
    public let data: Data

    public var string: String {
        return try! data |> UTF8.init |> String.init
    }

    public var prettyString: String {
        let outputStream = OutputStream(toMemory: ())
        outputStream.open()
        defer { outputStream.close() }
        JSONSerialization.writeJSONObject(value, to: outputStream, options: [.prettyPrinted], error: nil)
        let data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        return String(data: data, encoding: .utf8)!
    }

    public var dictionary: Dictionary {
        return value as! Dictionary
    }

    public var array: Array {
        return value as! Array
    }

    public var dictionaryOfStrings: DictionaryOfStrings {
        return value as! DictionaryOfStrings
    }

    public var arrayOfDictionaries: ArrayOfDictionaries {
        return value as! ArrayOfDictionaries
    }

    public static func build(_ builds: (JSONBuilder) -> Void) -> JSON {
        let j = JSONBuilder()
        builds(j)
        return try! JSON(value: j.value)
    }

    public init(data: Data) throws {
        do {
            value = try JSONSerialization.jsonObject(with: data)
            self.data = data
        } catch(let error) {
            logError(error)
            throw error
        }
    }

    public init(value: Value) throws {
        do {
            data = try JSONSerialization.data(withJSONObject: value)
            self.value = value
        } catch(let error) {
            logError(error)
            throw error
        }
    }

    public init(string: String) throws {
        try self.init(data: string |> UTF8.init |> Data.init)
    }

    public static func isNull(_ value: Value) -> Bool {
        return value is NSNull
    }
    
    public static let null = NSNull()
}

extension FoundationJSON: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}
