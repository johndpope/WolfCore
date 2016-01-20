//
//  Point.swift
//  WolfCore
//
//  Created by Robert McNally on 1/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import CoreGraphics
#endif

public struct Point {
    public var x: Double
    public var y: Double
    
    public init() {
        x = 0
        y = 0
    }
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

#if os(iOS) || os(OSX) || os(tvOS)
    extension Point {
        public init(p: CGPoint) {
            x = Double(p.x)
            y = Double(p.y)
        }
        
        public var cgPoint: CGPoint {
            return CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
    }
#endif

extension Point: CustomStringConvertible {
    public var description: String {
        return("Point(\(x), \(y))")
    }
}

extension Point {
    public static let zero = Point()
    public static let infinite = Point(x: Double.infinity, y: Double.infinity)
    
    public init(x: Int, y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }
    
    public init(x: Float, y: Float) {
        self.x = Double(x)
        self.y = Double(y)
    }
}

extension Point: Equatable {
}

public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
