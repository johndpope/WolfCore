//
//  Monad.swift
//  WolfCore
//
//  Created by Robert McNally on 6/14/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

infix operator |> { associativity left }

@discardableResult public func |> <A, B>(lhs: A, rhs: (A) -> B) -> B {
    return rhs(lhs)
}

@discardableResult public func |> <A, B>(lhs: A, rhs: (A) throws -> B) throws -> B {
    return try rhs(lhs)
}

public func |> <A>(lhs: A, rhs: (A) -> Void) -> A {
    rhs(lhs)
    return lhs
}
