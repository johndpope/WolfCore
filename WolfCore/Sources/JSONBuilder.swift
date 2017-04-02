//
//  JSONBuilder.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

infix operator ∆ : AttributeAssignmentPrecedence

public class JSONBuilder {
    private var dict: JSON.Dictionary!
    private var array: JSON.Array!
    public var value: JSON.Value {
        if dict != nil {
            return dict
        } else {
            return array
        }
    }

    public init() { }

    @discardableResult public func set(_ key: String, to value: JSON.Value?, isNullable: Bool = false) -> JSONBuilder {
        assert(array == nil)
        if dict == nil {
            dict = JSON.Dictionary()
        }
        if let value = value {
            dict[key] = value
        } else {
            if isNullable {
                dict[key] = JSON.null
            }
        }
        return self
    }

    @discardableResult public func append(_ value: JSON.Value?, isNullable: Bool = false) -> JSONBuilder {
        assert(dict == nil)
        if array == nil {
            array = JSON.Array()
        }
        if let value = value {
            array.append(value)
        } else {
            if isNullable {
                array.append(JSON.null)
            }
        }
        return self
    }

    @discardableResult public static func ∆<T: JSONRepresentable>(lhs: JSONBuilder, rhs: (key: String, value: T)) -> JSONBuilder {
        return lhs.set(rhs.key, to: rhs.value.jsonRepresentation)
    }

    @discardableResult public static func ∆<T: JSONRepresentable>(lhs: JSONBuilder, rhs: (key: String, value: T?)) -> JSONBuilder {
        return lhs.set(rhs.key, to: rhs.value?.jsonRepresentation)
    }

    @discardableResult public static func ∆<T: JSONRepresentable>(lhs: JSONBuilder, rhs: T) -> JSONBuilder {
        return lhs.append(rhs.jsonRepresentation)
    }

    @discardableResult public static func ∆<T: JSONRepresentable>(lhs: JSONBuilder, rhs: T?) -> JSONBuilder {
        return lhs.append(rhs?.jsonRepresentation)
    }

    @discardableResult public static func ∆<T: JSONRepresentable>(lhs: JSONBuilder, rhs: (key: String, value: [T])) -> JSONBuilder {
        let a = rhs.value.map {
            return $0.jsonRepresentation
        }
        return lhs.set(rhs.key, to: a)
    }

    @discardableResult public static func ∆<T1: JSONRepresentable, T2: JSONRepresentable>(lhs: JSONBuilder, rhs: (key: String, value: Dictionary<T1, T2>)) -> JSONBuilder where T1.JSONValue == String {
        var d = JSON.Dictionary()
        rhs.value.forEach { (k, v) in
            d[k.jsonRepresentation] = v.jsonRepresentation
        }
        return lhs.set(rhs.key, to: d)
    }
}
