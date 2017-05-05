//
//  JSON.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias JSON = FoundationJSON

public typealias JSONPromise = Promise<JSON>

public struct FoundationJSON {
    private typealias `Self` = FoundationJSON

    public typealias Value = Any
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]
    public typealias DictionaryOfStrings = [String: String]
    public typealias ArrayOfStrings = [String]
    public typealias ArrayOfDictionaries = [Dictionary]

    public let value: Value
    public let data: Data!

    public var string: String {
        return try! data |> UTF8.init |> String.init
    }

    public var prettyString: String {
        let outputStream = OutputStream(toMemory: ())
        outputStream.open()
        defer { outputStream.close() }
        #if os(Linux)
            _ = try! JSONSerialization.writeJSONObject(value, toStream: outputStream, options: [.prettyPrinted])
        #else
            JSONSerialization.writeJSONObject(value, to: outputStream, options: [.prettyPrinted], error: nil)
        #endif
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

    public init(data: Data) throws {
        do {
            value = try JSONSerialization.jsonObject(with: data)
            self.data = data
        } catch let error {
            throw error
        }
    }

    public init(value: Value) throws {
        do {
            data = try JSONSerialization.data(withJSONObject: value)
            self.value = value
        } catch let error {
            logError(error)
            throw error
        }
    }

    private init(fragment: Value) {
        self.value = fragment
        self.data = nil
    }

    public init(_ n: Int) {
        self.init(fragment: n)
    }

    public init(_ d: Double) {
        self.init(fragment: d)
    }

    public init(_ f: Float) {
        self.init(fragment: f)
    }

    public init(_ s: String) {
        self.init(fragment: s)
    }

    public init(_ b: Bool) {
        self.init(fragment: b)
    }

    public init() {
        self.init(fragment: Self.null)
    }

    public init(_ inArray: [Any?]) {
        var outArray = [Value]()
        for inValue in inArray {
            if let inValue = inValue {
                if let v = inValue as? JSONRepresentable {
                    outArray.append(v.json.value)
                } else if let a = inValue as? [Any?] {
                    let j = JSON(a)
                    outArray.append(j.value)
                } else if let d = inValue as? [AnyHashable: Any?] {
                    let j = JSON(d)
                    outArray.append(j.value)
                } else {
                    fatalError("Not a JSON value.")
                }
            } else {
                outArray.append(Self.null)
            }
        }
        try! self.init(value: outArray)
    }

    public init(_ dict: [AnyHashable: Any?]) {
        var outDict = [String : Value]()
        for (name, inValue) in dict {
            let name = "\(name)"
            if let inValue = inValue {
                if let v = inValue as? JSONRepresentable {
                    outDict[name] = v.json.value
                } else if let a = inValue as? [Any?] {
                    let j = JSON(a)
                    outDict[name] = j.value
                } else if let d = inValue as? [AnyHashable: Any?] {
                    let j = JSON(d)
                    outDict[name] = j.value
                } else {
                    fatalError("Not a JSON value.")
                }
            }
        }
        try! self.init(value: outDict)
    }

    public init(string: String) throws {
        try self.init(data: string |> Data.init)
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
