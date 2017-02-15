//
//  ObjectExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/30/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

private var debugIdentifierKey = "debugIdentifier"

extension NSObject {
    /// A string used for debugging purposes that can be set on any NSObject.
    public var debugIdentifier: String? {
        get {
            return getAssociatedValue(for: &debugIdentifierKey)
        }

        set {
            setAssociatedValue(newValue, for: &debugIdentifierKey)
        }
    }
}


infix operator <- : ComparisonPrecedence

///
/// Inherits-From Operator
///
///     class A { }
///     class B: A { }
///
///     let b = B()
///
///     b <- UIView.self // prints false
///     b <- A.self      // prints true
///
///     2.0 <- Float.self   // prints false
///     2.0 <- Double.self  // prints true
///
/// - Parameter lhs: The instance to be tested for type.
/// - Parameter rhs: The type to be tested against.
///
public func <- <U, T>(lhs: U?, rhs: T.Type) -> Bool {
    return (lhs as? T) != nil
}
