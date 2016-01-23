//
//  JSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public typealias JSONObject = AnyObject
public typealias JSONDictionary = [String: JSONObject]
public typealias JSONDictionaryOfStrings = [String: String]
public typealias JSONArray = [JSONObject]
public typealias JSONArrayOfDictionaries = [JSONDictionary]

public class JSON {
    public static func encode(json: JSONObject) throws -> NSData {
        return try NSJSONSerialization.dataWithJSONObject(json, options: [])
    }
    
    public static func decode(data: NSData) throws -> JSONObject {
        #if os(Linux)
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as! AnyObject
        #else
            return try NSJSONSerialization.JSONObjectWithData(data, options: [])
        #endif
    }
    
    public static func decode(string: String) throws -> JSONObject {
        return try decode(UTF8.encode(string))
    }
}
