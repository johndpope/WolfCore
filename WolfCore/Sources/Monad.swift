//
//  Monad.swift
//  WolfCore
//
//  Created by Robert McNally on 6/14/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

infix operator |> { associativity left }


/// An operator to transform a monad.
///
/// - parameters:
///     - lhs: The monad to be transformed.
///     - rhs: The function to be called to perform the transformation.
@discardableResult public func |> <A, B>(lhs: A, rhs: (A) -> B) -> B {
    return rhs(lhs)
}

/// An operator to transform a monad. The transformation function may throw.
///
/// - parameters:
///     - lhs: The monad to be transformed.
///     - rhs: The function to be called to perform the transformation.
@discardableResult public func |> <A, B>(lhs: A, rhs: (A) throws -> B) throws -> B {
    return try rhs(lhs)
}

/// An operator used to transform a monad in place or where a side effect
/// of the transformation function is all that matters.
///
/// - parameters:
///     - lhs: The monad to be transformed.
///     - rhs: The function to be called to perform the transformation or
///             generate a side-effect.
public func |> <A>(lhs: A, rhs: (A) -> Void) -> A {
    rhs(lhs)
    return lhs
}
