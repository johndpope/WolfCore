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
    public func random() -> UInt32 {
        #if os(Linux)
            return Glibc.random()
        #else
            return arc4random()
        #endif
    }

    // returns a random Double in the half-open range 0..<1
    public func randomDouble() -> Double {
        return Double(random()) / Double(m)
    }

    // returns a random Float in the half-open range 0..<1
    public func randomFloat() -> Float {
        return Float(random()) / Float(m)
    }

#if os(iOS) || os(macOS) || os(tvOS)
    // returns a random CGFloat in the half-open range 0..<1
    public func randomCGFloat() -> CGFloat {
        return CGFloat(random()) / CGFloat(m)
    }
#endif

    // returns a random Double in the half-open range start..<end
    public func randomDouble(_ i: Interval<Double>) -> Double {
        return randomDouble().mapped(to: i)
    }

    // returns a random Float in the half-open range start..<end
    public func randomFloat(_ i: Interval<Float>) -> Float {
        return randomFloat().mapped(to: i)
    }

#if os(iOS) || os(macOS) || os(tvOS)
    // returns a random CGFloat in the half-open range start..<end
    public func randomCGFloat(_ i: Interval<CGFloat>) -> CGFloat {
        return randomCGFloat().mapped(to: i)
    }
#endif

    // returns an integer in the half-open range start..<end
    public func randomInt(_ i: CountableRange<Int>) -> Int {
        return Int(randomDouble(Double(i.lowerBound)..Double(i.upperBound)))
    }

    // returns an integer in the closed range start...end
    public func randomInt(_ i: CountableClosedRange<Int>) -> Int {
        return Int(randomDouble(Double(i.lowerBound)..Double(i.upperBound + 1)))
    }

    // returns a random boolean
    public func randomBoolean() -> Bool {
        return randomInt(0...1) > 0
    }

    // "Generating Gaussian Random Numbers"
    // http://www.taygeta.com/random/gaussian.html
    public func randomGaussian() -> Double {
        return sqrt( -2.0 * log(randomDouble()) ) * cos( 2.0 * .pi * randomDouble() )
    }

    // returns a random Double in the half-open range 0..<1
    public class func randomDouble() -> Double {
        return Random.sharedInstance.randomDouble()
    }

    // returns a random Float in the half-open range 0..<1
    public class func randomFloat() -> Float {
        return Random.sharedInstance.randomFloat()
    }

#if os(iOS) || os(macOS) || os(tvOS)
    // returns a random CGFloat in the half-open range 0..<1
    public class func randomCGFloat() -> CGFloat {
        return Random.sharedInstance.randomCGFloat()
    }
#endif

    public class func randomDouble(_ i: Interval<Double>) -> Double {
        return Random.sharedInstance.randomDouble(i)
    }

    // returns a random Float in the half-open range start..<end
    public class func randomFloat(_ i: Interval<Float>) -> Float {
        return Random.sharedInstance.randomFloat(i)
    }

#if os(iOS) || os(macOS) || os(tvOS)
    // returns a random CGFloat in the half-open range start..<end
    public class func randomCGFloat(_ i: Interval<CGFloat>) -> CGFloat {
        return Random.sharedInstance.randomCGFloat(i)
    }
#endif

    // returns an integer in the half-open range start..<end
    public class func randomInt(_ i: CountableRange<Int>) -> Int {
        return Random.sharedInstance.randomInt(i)
    }

    // returns an integer in the closed range start...end
    public class func randomInt(_ i: CountableClosedRange<Int>) -> Int {
        return Random.sharedInstance.randomInt(i)
    }

    // returns a random boolean
    public class func randomBoolean() -> Bool {
        return Random.sharedInstance.randomBoolean()
    }

    public class func randomChoice<T, C: Collection>(among choices: C) -> T where C.IndexDistance == Int, C.Iterator.Element == T {
        let offset = randomInt(Int(0) ..< choices.count)
        let index = choices.index(choices.startIndex, offsetBy: offset)
        return choices[index]
    }

    public class func randomChoice<T>(_ choices: T...) -> T {
        return randomChoice(among: choices)
    }
}
