//
//  Interval.swift
//  WolfCore
//
//  Created by Robert McNally on 6/19/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

infix operator .. { }

public func .. <T: FloatingPoint>(left: T, right: T) -> Interval<T> {
    return Interval(a: left, b: right)
}

public struct Interval<T: FloatingPoint> {
    public let a: T
    public let b: T

    public init(a: T, b: T) {
        self.a = a
        self.b = b
    }

    public init(_ i: ClosedRange<T>) {
        self.a = i.lowerBound
        self.b = i.upperBound
    }

    public var closedRange: ClosedRange<T> {
        return a <= b ? a...b : b...a
    }
}
