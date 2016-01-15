//
//  Types.swift
//  WolfCore
//
//  Created by Robert McNally on 7/1/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

public typealias Byte = UInt8
public typealias Bytes = [Byte]

public typealias Frac = Double // 0.0...1.0

#if os(iOS) || os(OSX) || os(tvOS)
public typealias JSONObject = AnyObject
#else
public typealias JSONObject = Any
#endif
public typealias JSONDictionary = [String: JSONObject]
public typealias JSONDictionaryOfStrings = [String: String]
public typealias JSONArray = [JSONObject]
public typealias JSONArrayOfDictionaries = [JSONDictionary]
