//
//  JSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

#if os(Linux)
    public typealias JSONObject = AnyObject
#else
    public typealias JSONObject = AnyObject
#endif
public typealias JSONDictionary = [String: JSONObject]
public typealias JSONDictionaryOfStrings = [String: String]
public typealias JSONArray = [JSONObject]
public typealias JSONArrayOfDictionaries = [JSONDictionary]

public class JSON {
    public static func encode(json: JSONObject) throws -> NSData {
        #if os(Linux)
            // throw Unimplemented()
            return try NSJSONSerialization.dataWithJSONObject(json, options: [])
        #else
            return try NSJSONSerialization.dataWithJSONObject(json, options: [])
        #endif
    }

    public static func decode(data: NSData) throws -> JSONObject {
        #if os(Linux)
            // throw Unimplemented()
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as! JSONObject
        #else
            return try NSJSONSerialization.JSONObjectWithData(data, options: [])
        #endif
    }

    public static func decode(string: String) throws -> JSONObject {
        return try decode(UTF8.encode(string))
    }
}
