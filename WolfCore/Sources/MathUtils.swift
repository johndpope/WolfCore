//
//  MathUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/1/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import CoreGraphics
#elseif os(Linux)
    import Glibc
#endif


public typealias Frac = Double // 0.0..1.0

infix operator .. { }

public func .. <T: BinaryFloatingPoint>(left: T, right: T) -> Interval<T> {
    return Interval(a: left, b: right)
}

public struct Interval<T: BinaryFloatingPoint> {
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

/// The value mapped from the interval `a..b` into the interval `0..1`. (`a` may be greater than `b`).
public func map<T: BinaryFloatingPoint>(value v: T, from i: Interval<T>) -> T {
    return (v - i.a) / (i.b - i.a)
}

/// The value mapped from the interval `0..1` to the interval `a..b`. (`a` may be greater than `b`).
public func map<T: BinaryFloatingPoint>(value v: T, to i: Interval<T>) -> T {
    return v * (i.b - i.a) + i.b
}

/// The value mapped from the interval `a1..b1` to the interval `a2..b2`. (the `a`'s may be greater than the `b`'s).
public func map<T: BinaryFloatingPoint>(value v: T, from i1: Interval<T>, to i2: Interval<T>) -> T {
    return i1.b + ((i2.b - i1.b) * (v - i1.a)) / (i2.a - i1.a)
}

public func circularInterpolate<T: BinaryFloatingPoint>(value: T, to i: Interval<T>) -> T {
    let c = abs(i.a - i.b)
    if c <= 0.5 {
        return map(value: value, to: i)
    } else {
        var s: T
        if i.a <= i.b {
            s = map(value: value, to: i.a .. i.b - 1.0)
            if s < 0.0 { s += 1.0 }
        } else {
            s = map(value: value, to: i.a .. i.b + 1.0)
            if s >= 1.0 { s -= 1.0 }
        }
        return s
    }
}

extension Float {
    /// The value mapped from the interval `a..b` into the interval `0..1`. (`a` may be greater than `b`).
    public func mapped(from i: Interval<Float>) -> Float {
        return WolfCore.map(value: self, from: i)
    }

    /// The value mapped from the interval `0..1` to the interval `a..b`. (`a` may be greater than `b`).
    public func mapped(to i: Interval<Float>) -> Float {
        return WolfCore.map(value: self, to: i)
    }

    /// The value mapped from the interval `a1..b1` to the interval `a2..b2`. (the `a`'s may be greater than the `b`'s).
    public func mapped(from: Interval<Float>, to: Interval<Float>) -> Float {
        return WolfCore.map(value: self, from: from, to: to)
    }

    public var fractionalPart: Float { return self - floorf(self) }

    public func circularInterpolate(to i: Interval<Float>) -> Float {
        return WolfCore.circularInterpolate(value: self, to: i)
    }

    public var clamped: Float {
        return max(min(self, 1.0), 0.0)
    }
}

extension Double {
    /// The value mapped from the interval `a..b` into the interval `0..1`. (`a` may be greater than `b`).
    public func mapped(from i: Interval<Double>) -> Double {
        return WolfCore.map(value: self, from: i)
    }

    /// The value mapped from the interval `0..1` to the interval `a..b`. (`a` may be greater than `b`).
    public func mapped(to i: Interval<Double>) -> Double {
        return WolfCore.map(value: self, to: i)
    }

    /// The value mapped from the interval `a1..b1` to the interval `a2..b2`. (the `a`'s may be greater than the `b`'s).
    public func mapped(from: Interval<Double>, to: Interval<Double>) -> Double {
        return WolfCore.map(value: self, from: from, to: to)
    }

    public var fractionalPart: Double { return self - floor(self) }

    public func circularInterpolate(to i: Interval<Double>) -> Double {
        return WolfCore.circularInterpolate(value: self, to: i)
    }

    public var clamped: Double {
        return max(min(self, 1.0), 0.0)
    }
}

#if os(iOS) || os(OSX) || os(tvOS)
    extension CGFloat {
        /// The value mapped from the interval `a..b` into the interval `0..1`. (`a` may be greater than `b`).
        public func mapped(from i: Interval<CGFloat>) -> CGFloat {
            return WolfCore.map(value: self, from: i)
        }

        /// The value mapped from the interval `0..1` to the interval `a..b`. (`a` may be greater than `b`).
        public func mapped(to i: Interval<CGFloat>) -> CGFloat {
            return WolfCore.map(value: self, to: i)
        }

        /// The value mapped from the interval `a1..b1` to the interval `a2..b2`. (the `a`'s may be greater than the `b`'s).
        public func mapped(from: Interval<CGFloat>, to: Interval<CGFloat>) -> CGFloat {
            return WolfCore.map(value: self, from: from, to: to)
        }

        public var fractionalPart: CGFloat { return self - floor(self) }

        public func circularInterpolate(to i: Interval<CGFloat>) -> CGFloat {
            return WolfCore.circularInterpolate(value: self, to: i)
        }

        public static func min(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
            return x <= y ? x : y
        }

        public static func max(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
            return x >= y ? x : y
        }

        public var clamped: CGFloat {
            return CGFloat.max(CGFloat.min(self, 1.0), 0.0)
        }
    }
#endif
