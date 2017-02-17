//
//  Random.swift
//  WolfCore
//
//  Created by Robert McNally on 1/10/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import CoreGraphics
    import Security
#endif

private var _instance = Random()

public class Random {
    #if os(Linux)
        let m: UInt64 = UInt64(RAND_MAX) + 1
    #else
        let m: UInt64 = 1 << 32
    #endif

    public class var sharedInstance: Random {
        get {
            return _instance
        }
    }

#if os(iOS) || os(macOS) || os(tvOS)
    public func cryptoRandom() -> Int32 {
        let a = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        defer {
            a.deallocate(capacity: 1)
        }
        a.withMemoryRebound(to: UInt8.self, capacity: 4) { p in
            _ = SecRandomCopyBytes(kSecRandomDefault, 4, p)
        }
        let n = a.pointee
        return n
    }
#endif

    // returns a random Int32 in the half-open range 0..<(2**32)
    private func randomBase() -> UInt32 {
        #if os(Linux)
            return Glibc.random()
        #else
            return arc4random()
        #endif
    }

    // returns a random number in the half-open range 0..<1
    public func number<T: BinaryFloatingPoint>() -> T {
        return T(randomBase()) / T(m)
    }

    // returns a random number in the half-open range start..<end
    public func number<T: BinaryFloatingPoint>(_ i: Interval<T>) -> T {
        let n: T = number()
        return n.mapped(to: i)
    }

    // returns an integer in the half-open range start..<end
    public func number(_ i: CountableRange<Int>) -> Int {
        return Int(number(Double(i.lowerBound)..Double(i.upperBound)))
    }

    // returns an integer in the closed range start...end
    public func number(_ i: CountableClosedRange<Int>) -> Int {
        return Int(number(Double(i.lowerBound)..Double(i.upperBound + 1)))
    }

    // returns a random boolean
    public func boolean() -> Bool {
        return number(0...1) > 0
    }

    // "Generating Gaussian Random Numbers"
    // http://www.taygeta.com/random/gaussian.html
    public func gaussian() -> Double {
        return sqrt( -2.0 * log(number()) ) * cos( 2.0 * .pi * number() )
    }

    // returns a random number in the half-open range 0..<1
    public class func number<T: BinaryFloatingPoint>() -> T {
        return Random.sharedInstance.number()
    }

    public class func number<T: BinaryFloatingPoint>(_ i: Interval<T>) -> T {
        return Random.sharedInstance.number(i)
    }

    // returns an integer in the half-open range start..<end
    public class func number(_ i: CountableRange<Int>) -> Int {
        return Random.sharedInstance.number(i)
    }

    // returns an integer in the closed range start...end
    public class func number(_ i: CountableClosedRange<Int>) -> Int {
        return Random.sharedInstance.number(i)
    }

    // returns a random boolean
    public class func boolean() -> Bool {
        return Random.sharedInstance.boolean()
    }

    public class func choice<T, C: Collection>(among choices: C) -> T where C.IndexDistance == Int, C.Iterator.Element == T {
        let offset = number(Int(0) ..< choices.count)
        let index = choices.index(choices.startIndex, offsetBy: offset)
        return choices[index]
    }

    public class func choice<T>(_ choices: T...) -> T {
        return choice(among: choices)
    }
}
