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
    public func value<T>(for key: String) throws -> T? {
        guard let value = dictionary[key] else { return nil }
        if let v = value as? T {
            return v
        } else if JSON.isNull(value) {
            return nil
        } else {
            throw Error.wrongType(key, value)
        }
    }

    /// Get a value of RawRepresentable type `T` for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be used as a valid `rawValue` of the type `T`.
    public func value<T: RawRepresentable>(for key: String) throws -> T? where T.RawValue == String {
        guard let s: String = try value(for: key) else { return nil }
        guard let v = T(rawValue: s) else { throw Error.wrongType(key, s) }
        return v
    }

    public func value(for key: String) throws -> JSON? {
        guard let v: JSON.Value = try value(for: key) else { return nil }
        return try JSON(value: v)
    }

    /// Get a value of JSONModel type `T` for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be used as a valid JSON.Dictionary.
    public func value<T: JSONModel>(for key: String) throws -> T? {
        guard let v: JSON = try value(for: key) else { return nil }
        return T(json: v)
    }

    /// Get a `UIColor` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a color.
    public func value(for key: String) throws -> UIColor? {
        guard let s: String = try value(for: key) else { return nil }
        return UIColor(try Color(string: s))
    }

    /// Get a `URL` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a `URL`.
    public func value(for key: String) throws -> URL? {
        guard let s: String = try value(for: key) else { return nil }
        guard let url = URL(string: s) else { throw Error.wrongType(key, s) }
        return url
    }

    /// Get a `Date` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a `Date`.
    public func value(for key: String) throws -> Date? {
        guard let s: String = try value(for: key) else { return nil }
        return try Date(iso8601: s)
    }
}

extension JSON {
    public func value<T, U>(for key: String, fallback: T? = nil, f: (U) throws -> T) throws -> T {
        if let v = try value(for: key) as U? {
            return try f(v)
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }

    /// Get a value of type `T` for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to the generic type `T`.
    public func value<T>(for key: String, fallback: T? = nil) throws -> T {
        return try value(for: key, fallback: fallback) { return $0 }
    }

    /// Get a value of the RawRepresentable type `T` for a given key in the JSON dictionary. If 
    /// the `fallback` argument is provided, it will be substituted only if the key is `null` or nonexistent.
    /// An error will be thrown if the value exists but cannot be used as a valid `rawValue` of `T`.
    public func value<T: RawRepresentable>(for key: String, fallback: T? = nil) throws -> T where T.RawValue == String {
        return try value(for: key, fallback: fallback) { (s: T.RawValue) throws -> T in
            guard let v = T(rawValue: s) else { throw Error.wrongType(key, s) }
            return v
        }
    }

    public func value(for key: String, fallback: JSON? = nil) throws -> JSON {
        return try value(for: key, fallback: fallback) { (v: JSON.Value) throws -> JSON in
            return try JSON(value: v)
        }
    }

    /// Get a value of the JSONModel type `T` for a given key in the JSON dictionary. If
    /// the `fallback` argument is provided, it will be substituted only if the key is `null` or nonexistent.
    /// An error will be thrown if the value exists but cannot be used as a valid JSON.Dictionary
    public func value<T: JSONModel>(for key: String, fallback: T? = nil) throws -> T {
        return try value(for: key, fallback: fallback) { (v: JSON.Value) throws -> T in
            return try T(json: JSON(value: v))
        }
    }

    /// Get a `UIColor` value for a given key in the JSON dictionary. The color will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `UIColor`.
    public func value(for key: String, fallback: UIColor? = nil) throws -> UIColor {
        return try value(for: key, fallback: fallback) {
            return try UIColor(Color(string: $0))
        }
    }

    /// Get a `URL` value for a given key in the JSON dictionary. The URL will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `URL`.
    public func value(for key: String, fallback: URL? = nil) throws -> URL {
        return try value(for: key, fallback: fallback) { (s: String) throws -> URL in
            guard let url = URL(string: s) else { throw Error.wrongType(key, s) }
            return url
        }
    }

    /// Get a `Date` value for a given key in the JSON dictionary. The URL will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `Date`.
    public func value(for key: String, fallback: Date? = nil) throws -> Date {
        return try value(for: key, fallback: fallback) {
            return try Date(iso8601: $0)
        }
    }
}
