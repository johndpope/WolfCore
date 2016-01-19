//
//  Point.swift
//  WolfCore
//
//  Created by Robert McNally on 1/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import CoreGraphics
#elseif os(Linux)
    import Glibc
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

extension Point {
    public init(vector: Vector) {
        x = vector.dx
        y = vector.dy
    }

    public init(center: Point, angle theta: Double, radius: Double) {
        x = center.x + cos(theta) * radius
        y = center.y + sin(theta) * radius
    }

    public var magnitude: Double {
        return hypot(x, y)
    }

    public var angle: Double {
        return atan2(y, x)
    }

    public func rotatedByAngle(theta: Double, aroundCenter center: Point) -> Point {
        let v = center - self
        let v2 = v.rotatedByAngle(theta)
        let p = center + v2
        return p
    }
}

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

public func -(lhs: Point, rhs: Point) -> Vector {
    return Vector(dx: rhs.x - lhs.x, dy: rhs.y - lhs.y)
}

public func +(lhs: Point, rhs: Vector) -> Point {
    return Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}
