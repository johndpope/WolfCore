//
//  MathUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/1/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
    import CoreGraphics
#elseif os(Linux)
    import Glibc
#endif

import Foundation

extension Int {
    public func mapped<T: BinaryFloatingPoint>(from r: CountableRange<Int>, to i: Interval<T>) -> T {
        return T(self).mapped(from: T(r.lowerBound)..T(r.upperBound - 1), to: i)
    }

    public func mapped<T: BinaryFloatingPoint>(from r: CountableClosedRange<Int>, to i: Interval<T>) -> T {
        return T(self).mapped(from: T(r.lowerBound)..T(r.upperBound), to: i)
    }
}

extension BinaryFloatingPoint {
    /// The value mapped from the interval `a..b` into the interval `0..1`. (`a` may be greater than `b`).
    public func mapped(from i: Interval<Self>) -> Self {
        return (self - i.a) / (i.b - i.a)
    }

    /// The value mapped from the interval `0..1` to the interval `a..b`. (`a` may be greater than `b`).
    public func mapped(to i: Interval<Self>) -> Self {
        return self * (i.b - i.a) + i.a
    }

    /// The value mapped from the interval `a1..b1` to the interval `a2..b2`. (the `a`'s may be greater than the `b`'s).
    public func mapped(from i1: Interval<Self>, to i2: Interval<Self>) -> Self {
        return i2.a + ((i2.b - i2.a) * (self - i1.a)) / (i1.b - i1.a)
    }

    public var fractionalPart: Self {
        return self - rounded(.towardZero)
    }

    public func circularInterpolate(to i: Interval<Self>) -> Self {
        let c = abs(i.a - i.b)
        if c <= 0.5 {
            return self.mapped(to: i)
        } else {
            var s: Self
            if i.a <= i.b {
                s = self.mapped(to: i.a .. i.b - 1.0)
                if s < 0.0 { s += 1.0 }
            } else {
                s = self.mapped(to: i.a .. i.b + 1.0)
                if s >= 1.0 { s -= 1.0 }
            }
            return s
        }
    }

    public var clamped: Self {
        return max(min(self, 1.0), 0.0)
    }

    public var ledge: Bool {
        return self < 0.5
    }

    public func ledge<T>(_ a: @autoclosure () -> T, _ b: @autoclosure () -> T) -> T {
        return self.ledge ? a() : b()
    }
}

public func binarySearch<T: BinaryFloatingPoint>(interval: Interval<T>, start: T, compare: (T) -> ComparisonResult) -> T {
    var current = start
    var interval = interval
    while true {
        switch compare(current) {
        case .orderedSame:
            return current
        case .orderedAscending:
            interval = current..interval.b
            current = T(0.5).mapped(to: interval)
        case .orderedDescending:
            interval = interval.a..current
            current = T(0.5).mapped(to: interval)
        }
    }
}

extension Integer {
    public var isEven: Bool {
        return (self & 1) == 0
    }

    public var isOdd: Bool {
        return (self & 1) == 1
    }
}
