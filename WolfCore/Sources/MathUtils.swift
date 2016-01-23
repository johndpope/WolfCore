//
//  MathUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/1/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import UIKit
#elseif os(Linux)
    import Glibc
#endif


public typealias Frac = Double // 0.0...1.0


public class Math {
}

// Float
extension Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize(value: Float, _ i1: Float, _ i2: Float) -> Float { return (value - i1) / (i2 - i1) }

    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize(value: Float, _ i1: Float, _ i2: Float) -> Float { return value * (i2 - i1) + i1 }

    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate(value: Float, _ i1: Float, _ i2: Float) -> Float { return value * (i2 - i1) + i1 }

    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map(value: Float, _ a1: Float, _ a2: Float, _ b1: Float, _ b2: Float) -> Float { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

    // The value clamped into the given interval (default 0...1)
    public class func clamp(value: Float, _ i: ClosedInterval<Float> = 0...1) -> Float { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }

    // The interval clamped into another interval
    public class func clamp(value: ClosedInterval<Float>, intervalToClamp: ClosedInterval<Float>) -> ClosedInterval<Float> {
        return value.clamp(intervalToClamp)
    }

    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign(value: Float) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

    // returns fractional part
    public class func fract(value: Float) -> Float { return value - floorf(value) }

    public class func circularInterpolate(value: Float, _ i1: Float, _ i2: Float) -> Float
    {
        let c = Float.abs(i2 - i1)
        if c <= 0.5 {
            return denormalize(value, i1, i2)
        } else {
            var s: Float
            if i1 <= i2 {
                s = denormalize(value, i1, i2 - 1.0)
                if s < 0.0 { s += 1.0 }
            } else {
                s = denormalize(value, i1, i2 + 1.0)
                if s >= 1.0 { s -= 1.0 }
            }
            return s
        }
    }
}

// Double
extension Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize(value: Double, _ i1: Double, _ i2: Double) -> Double { return (value - i1) / (i2 - i1) }

    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize(value: Double, _ i1: Double, _ i2: Double) -> Double { return value * (i2 - i1) + i1 }

    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate(value: Double, _ i1: Double, _ i2: Double) -> Double { return value * (i2 - i1) + i1 }

    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map(value: Double, _ a1: Double, _ a2: Double, _ b1: Double, _ b2: Double) -> Double { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

    // The value clamped into the given interval (default 0...1)
    public class func clamp(value: Double, _ i: ClosedInterval<Double> = 0...1) -> Double { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }

    // The interval clamped into another interval
    public class func clamp(value: ClosedInterval<Double>, intervalToClamp: ClosedInterval<Double>) -> ClosedInterval<Double> {
        return value.clamp(intervalToClamp)
    }

    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign(value: Double) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

    // returns fractional part
    public class func fract(value: Double) -> Double { return value - floor(value) }

    public class func circularInterpolate(value: Double, _ i1: Double, _ i2: Double) -> Double
    {
        let c = Double.abs(i2 - i1)
        if c <= 0.5 {
            return denormalize(value, i1, i2)
        } else {
            var s: Double
            if i1 <= i2 {
                s = denormalize(value, i1, i2 - 1.0)
                if s < 0.0 { s += 1.0 }
            } else {
                s = denormalize(value, i1, i2 + 1.0)
                if s >= 1.0 { s -= 1.0 }
            }
            return s
        }
    }
}

#if os(iOS) || os(OSX) || os(tvOS)
// CGFloat
extension Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat { return (value - i1) / (i2 - i1) }

    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat { return value * (i2 - i1) + i1 }

    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat { return value * (i2 - i1) + i1 }

    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map(value: CGFloat, _ a1: CGFloat, _ a2: CGFloat, _ b1: CGFloat, _ b2: CGFloat) -> CGFloat { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

    // The value clamped into the given interval (default 0...1)
    public class func clamp(value: CGFloat, _ i: ClosedInterval<CGFloat> = 0...1) -> CGFloat { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }

    // The interval clamped into another interval
    public class func clamp(value: ClosedInterval<CGFloat>, intervalToClamp: ClosedInterval<CGFloat>) -> ClosedInterval<CGFloat> {
        return value.clamp(intervalToClamp)
    }

    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign(value: CGFloat) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

    // returns fractional part
    public class func fract(value: CGFloat) -> CGFloat { return value - floor(value) }

    public class func circularInterpolate(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat
    {
        let c = CGFloat.abs(i2 - i1)
        if c <= 0.5 {
            return denormalize(value, i1, i2)
        } else {
            var s: CGFloat
            if i1 <= i2 {
                s = denormalize(value, i1, i2 - 1.0)
                if s < 0.0 { s += 1.0 }
            } else {
                s = denormalize(value, i1, i2 + 1.0)
                if s >= 1.0 { s -= 1.0 }
            }
            return s
        }
    }
}
#endif
