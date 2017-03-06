//
//  JSONUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/2/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation
import UIKit

extension JSON {
    public enum Error: Swift.Error {
        case missingKey(String)
        case wrongType(String, Any)
        case notAnArray(String, Any)
        case notAnArrayOfStrings(String, Array)
    }
}

extension JSON {
    /// Get a value of type `T` for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the type of the value cannot be cast to the generic type `T`.
    public static func value<T>(for key: String, in dict: JSON.Dictionary) throws -> T? {
        guard let value = dict[key] else { return nil }
        if let v = value as? T {
            return v
        } else if JSON.isNull(value) {
            return nil
        } else {
            throw Error.wrongType(key, value)
        }
    }

    /// Get a `String` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to a `String`.
    public static func string(for key: String, in dict: JSON.Dictionary) throws -> String? {
        return try value(for: key, in: dict)
    }

    /// Get a value of RawRepresentable type `T` fir a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be used as a valid `rawValue` of the type `T`.
    public static func value<T: RawRepresentable>(for key: String, in dict: JSON.Dictionary) throws -> T? where T.RawValue == String {
        guard let s = try string(for: key, in: dict) else { return nil }
        guard let v = T(rawValue: s) else { throw Error.wrongType(key, s) }
        return v
    }

    /// Get an `Int` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to an `Int`.
    public static func int(for key: String, in dict: JSON.Dictionary) throws -> Int? {
        return try value(for: key, in: dict)
    }

    /// Get a `Double` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to a `Double`.
    public static func double(for key: String, in dict: JSON.Dictionary) throws -> Double? {
        return try value(for: key, in: dict)
    }

    /// Get a `CGFloat` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to a `CGFloat`.
    public static func cgFloat(for key: String, in dict: JSON.Dictionary) throws -> CGFloat? {
        return try value(for: key, in: dict)
    }

    /// Get a `UIColor` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a color.
    public static func color(for key: String, in dict: JSON.Dictionary) throws -> UIColor? {
        guard let s = try string(for: key, in: dict) else { return nil }
        let color = try Color(string: s)
        return UIColor(color)
    }

    /// Get a `URL` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a `URL`.
    public static func url(for key: String, in dict: JSON.Dictionary) throws -> URL? {
        guard let s = try string(for: key, in: dict) else { return nil }
        guard let url = URL(string: s) else { throw Error.wrongType(key, s) }
        return url
    }

    /// Get a `Date` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a `Date`.
    public static func date(for key: String, in dict: JSON.Dictionary) throws -> Date? {
        guard let s = try string(for: key, in: dict) else { return nil }
        return try Date(iso8601: s)
    }

    /// Get a `JSON.Array` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to a `JSON.Array`.
    public static func array(for key: String, in dict: JSON.Dictionary) throws -> JSON.Array? {
        return try value(for: key, in: dict)
    }

    /// Get a `JSON.ArrayOfStrings` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to a `JSON.ArrayOfStrings`.
    public static func arrayOfStrings(for key: String, in dict: JSON.Dictionary) throws -> JSON.ArrayOfStrings? {
        return try value(for: key, in: dict)
    }

    /// Get a `JSON.ArrayOfDictionaries` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be cast to a `JSON.ArrayOfDictionaries`.
    public static func arrayOfDictionaries(for key: String, in dict: JSON.Dictionary) throws -> JSON.ArrayOfDictionaries? {
        return try value(for: key, in: dict)
    }
}

extension JSON {
    /// Get a value of type `T` for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to the generic type `T`.
    public static func value<T>(for key: String, in dict: JSON.Dictionary, fallback: T? = nil) throws -> T {
        if let v = try value(for: key, in: dict) as T? {
            return v
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }

    /// Get a `String` value for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to a `String`.
    public static func string(for key: String, in dict: JSON.Dictionary, fallback: String? = nil) throws -> String {
        return try value(for: key, in: dict, fallback: fallback)
    }

    /// Get a value of the RawRepresentable type `T` for a given key in the JSON dictionary. If 
    /// the `fallback` argument is provided, it will be substituted only if the key is `null` or nonexistent.
    /// An error will be thrown if the value exists but cannot be used as a valid `rawValue` of `T`.
    public static func value<T: RawRepresentable>(for key: String, in dict: JSON.Dictionary, fallback: T? = nil) throws -> T where T.RawValue == String {
        if let s = try string(for: key, in: dict) {
            if let v = T(rawValue: s) {
                return v
            } else {
                throw Error.wrongType(key, s)
            }
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }

    /// Get an `Int` value for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to an `Int`.
    public static func int(for key: String, in dict: JSON.Dictionary, fallback: Int? = nil) throws -> Int {
        return try value(for: key, in: dict, fallback: fallback)
    }

    /// Get a `Double` value for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to a `Double`.
    public static func double(for key: String, in dict: JSON.Dictionary, fallback: Double? = nil) throws -> Double {
        return try value(for: key, in: dict, fallback: fallback)
    }

    /// Get a `CGFloat` value for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to a `CGFloat`.
    public static func cgFloat(for key: String, in dict: JSON.Dictionary, fallback: CGFloat? = nil) throws -> CGFloat {
        return try value(for: key, in: dict, fallback: fallback)
    }

    /// Get a `UIColor` value for a given key in the JSON dictionary. The color will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `UIColor`.
    public static func color(for key: String, in dict: JSON.Dictionary, fallback: UIColor? = nil) throws -> UIColor {
        if let s = try string(for: key, in: dict) {
            let color = try Color(string: s)
            return UIColor(color)
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }

    /// Get a `URL` value for a given key in the JSON dictionary. The URL will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `URL`.
    public static func url(for key: String, in dict: JSON.Dictionary, fallback: URL? = nil) throws -> URL {
        if let s = try string(for: key, in: dict) {
            guard let url = URL(string: s) else { throw Error.wrongType(key, s) }
            return url
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }

    /// Get a `Date` value for a given key in the JSON dictionary. The URL will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `Date`.
    public static func date(for key: String, in dict: JSON.Dictionary, fallback: Date? = nil) throws -> Date {
        if let s = try string(for: key, in: dict) {
            return try Date(iso8601: s)
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }

    /// Get a `JSON.Array` value for a given key in the JSON dictionary. If the `fallback` argument is
    /// provided, it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast into a `JSON.Array`.
    public static func array(for key: String, in dict: JSON.Dictionary, fallback: JSON.Array? = nil) throws -> JSON.Array {
        return try value(for: key, in: dict, fallback: fallback)
    }

    /// Get a `JSON.ArrayOfStrings` value for a given key in the JSON dictionary. If the `fallback` argument is
    /// provided, it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast into a `JSON.ArrayOfStrings`.
    public static func arrayOfStrings(for key: String, in dict: JSON.Dictionary, fallback: JSON.ArrayOfStrings? = nil) throws -> JSON.ArrayOfStrings {
        return try value(for: key, in: dict, fallback: fallback)
    }

    /// Get a `JSON.ArrayOfDictionaries` value for a given key in the JSON dictionary. If the `fallback` argument is
    /// provided, it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast into a `JSON.ArrayOfDictionaries`.
    public static func arrayOfDictionaries(for key: String, in dict: JSON.Dictionary, fallback: JSON.ArrayOfDictionaries? = nil) throws -> JSON.ArrayOfDictionaries {
        return try value(for: key, in: dict, fallback: fallback)
    }
}
