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
    import Darwin.C
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

#if os(iOS) || os(OSX) || os(tvOS)
    public func cryptoRandom() -> Int32 {
        let a: UnsafeMutablePointer<Int32>! = .alloc(1)
        SecRandomCopyBytes(kSecRandomDefault, 4, UnsafeMutablePointer<Byte>(a))
        let n = a.memory
        a.dealloc(1)
        return n
    }
#endif

    // returns a random Int32 in the half-open interval 0..<(2**32)
    public func random() -> UInt32 {
        #if os(Linux)
            return random()
        #else
            return arc4random()
        #endif
    }

    // returns a random Double in the half-open interval 0..<1
    public func randomDouble() -> Double {
        return Double(random()) / Double(m)
    }

    // returns a random Float in the half-open interval 0..<1
    public func randomFloat() -> Float {
        return Float(random()) / Float(m)
    }

#if os(iOS) || os(OSX) || os(tvOS)
    // returns a random CGFloat in the half-open interval 0..<1
    public func randomCGFloat() -> CGFloat {
        return CGFloat(random()) / CGFloat(m)
    }
#endif

    // returns a random Double in the half-open interval start..<end
    public func randomDouble(i: HalfOpenInterval<Double>) -> Double {
        return Math.denormalize(randomDouble(), i.start, i.end)
    }

    // returns a random Float in the half-open interval start..<end
    public func randomFloat(i: HalfOpenInterval<Float>) -> Float {
        return Math.denormalize(randomFloat(), i.start, i.end)
    }

#if os(iOS) || os(OSX) || os(tvOS)
    // returns a random CGFloat in the half-open interval start..<end
    public func randomCGFloat(i: HalfOpenInterval<CGFloat>) -> CGFloat {
        return Math.denormalize(randomCGFloat(), i.start, i.end)
    }
#endif

    // returns an integer in the half-open interval start..<end
    public func randomInt(i: HalfOpenInterval<Int>) -> Int {
        return Int(randomDouble(Double(i.start)..<Double(i.end)))
    }

    // returns an integer in the closed interval start...end
    public func randomInt(i: ClosedInterval<Int>) -> Int {
        return Int(randomDouble(Double(i.start)..<Double(i.end + 1)))
    }

    // returns a random boolean
    public func randomBoolean() -> Bool {
        return randomInt(0...1) > 0
    }

    // "Generating Gaussian Random Numbers"
    // http://www.taygeta.com/random/gaussian.html
    public func randomGaussian() -> Double {
        return sqrt( -2.0 * log(randomDouble()) ) * cos( 2.0 * M_PI * randomDouble() )
    }

    // returns a random Double in the half-open interval 0..<1
    public class func randomDouble() -> Double {
        return Random.sharedInstance.randomDouble()
    }

    // returns a random Float in the half-open interval 0..<1
    public class func randomFloat() -> Float {
        return Random.sharedInstance.randomFloat()
    }

#if os(iOS) || os(OSX) || os(tvOS)
    // returns a random CGFloat in the half-open interval 0..<1
    public class func randomCGFloat() -> CGFloat {
        return Random.sharedInstance.randomCGFloat()
    }
#endif

    public class func randomDouble(i: HalfOpenInterval<Double>) -> Double {
        return Random.sharedInstance.randomDouble(i)
    }

    // returns a random Float in the half-open interval start..<end
    public class func randomFloat(i: HalfOpenInterval<Float>) -> Float {
        return Random.sharedInstance.randomFloat(i)
    }

#if os(iOS) || os(OSX) || os(tvOS)
    // returns a random CGFloat in the half-open interval start..<end
    public class func randomCGFloat(i: HalfOpenInterval<CGFloat>) -> CGFloat {
        return Random.sharedInstance.randomCGFloat(i)
    }
#endif

    // returns an integer in the half-open interval start..<end
    public class func randomInt(i: HalfOpenInterval<Int>) -> Int {
        return Random.sharedInstance.randomInt(i)
    }

    // returns an integer in the closed interval start...end
    public class func randomInt(i: ClosedInterval<Int>) -> Int {
        return Random.sharedInstance.randomInt(i)
    }

    // returns a random boolean
    public class func randomBoolean() -> Bool {
        return Random.sharedInstance.randomBoolean()
    }
}
