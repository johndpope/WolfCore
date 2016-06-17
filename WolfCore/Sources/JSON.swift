//
//  JSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

//#if os(Linux)
    public typealias JSONObject = NSObject
//#else
//    public typealias JSONObject = AnyObject
//#endif
public typealias JSONDictionary = [NSString: JSONObject]
public typealias JSONDictionaryOfStrings = [NSString: NSString]
public typealias JSONArray = [JSONObject]
public typealias JSONArrayOfDictionaries = [JSONDictionary]

public class JSON {
    public static func data(from json: JSONObject) throws -> Data {
        return try JSONSerialization.data(withJSONObject: json, options: [])
    }
}

extension Data {
    public static func jsonObject(from data: Data) throws -> JSONObject {
        return try JSONSerialization.jsonObject(with: data, options: []) as! NSObject
    }
}

extension String {
    public static func jsonObject(from string: String) throws -> JSONObject {
        return try string |> String.utf8Data |> Data.jsonObject
    }
}

public func jsonValue<A: Any>(_ value: A) -> NSObject {
    switch value {
    case let string as String:
        return NSString(string: string)
    case let bool as Bool:
        return NSNumber(booleanLiteral: bool)
    case let int as Int:
        return NSNumber(integerLiteral: int)
    default:
        return NSNull()
    }
}

public func swiftValue<A: JSONObject>(_ value: A?) -> Any? {
    guard let value = value else {
        return nil
    }
    switch value {
    case let string as NSString:
        return String(string)
    case let number as NSNumber:
        return number
    default:
        return nil
    }
}
