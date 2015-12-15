//
//  DataExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/27/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation


// Provide conversions of NSData objects to and from Bytes.

extension NSData {
    public var byteArray: Bytes {
        var a = Bytes(count: length, repeatedValue: 0)
        getBytes(&a, length: length)
        return a
    }
    
    public convenience init(byteArray: Bytes) {
        self.init(bytes: byteArray, length: byteArray.count)
    }
}


// Provide conversions of NSData objects to and from String (UTF-8 encoding).

extension NSData {
    public var string: String? {
        return String(data: self, encoding: NSUTF8StringEncoding)
    }
    
    public convenience init?(string: String) {
        let bytes = string.bytes
        self.init(bytes: bytes, length: bytes.count)
    }
}


// Provide conversions of NSData objects to and from JSON objects

extension NSData {
    public var json: JSONObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: [])
        } catch(let error) {
            logError(error)
            return nil
        }
    }
    
    public convenience init?(json: JSONObject) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(json, options: [])
            self.init(data: data)
        } catch(let error) {
            logError(error)
            return nil
        }
    }
}
