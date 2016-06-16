//
//  JSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public typealias JSONObject = AnyObject
public typealias JSONDictionary = [String: JSONObject]
public typealias JSONDictionaryOfStrings = [String: String]
public typealias JSONArray = [JSONObject]
public typealias JSONArrayOfDictionaries = [JSONDictionary]

public class JSON {
    public static func data(from json: JSONObject) throws -> Data {
        return try JSONSerialization.data(withJSONObject: json, options: [])
    }
}

extension Data {
    public static func jsonObject(from data: Data) throws -> JSONObject {
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
}

extension String {
    public static func jsonObject(from string: String) throws -> JSONObject {
        return try string |> String.utf8Data |> Data.jsonObject
    }
}
