//
//  PointExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    public init(vector: CGVector) {
        x = vector.dx
        y = vector.dy
    }

    public init(center: CGPoint, angle theta: CGFloat, radius: CGFloat) {
        x = center.x + cos(theta) * radius
        y = center.y + sin(theta) * radius
    }

    public var magnitude: CGFloat {
        return hypot(x, y)
    }

    public var angle: CGFloat {
        return atan2(y, x)
    }

    public func rotated(by theta: CGFloat, aroundCenter center: CGPoint) -> CGPoint {
        let v = center - self
        let v2 = v.rotated(by: theta)
        let p = center + v2
        return p
    }
}

extension CGPoint {
    public var debugSummary: String {
        let joiner = Joiner(left: "(", right: ")")
        joiner.append(x %% 3, y %% 3)
        return joiner.description
    }
}

public func + (left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(dx: left.x + right.x, dy: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(dx: left.x - right.x, dy: left.y - right.y)
}

public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

public func + (left: CGVector, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.dx + right.x, y: left.dy + right.y)
}

public func - (left: CGVector, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.dx - right.x, y: left.dy - right.y)
}
