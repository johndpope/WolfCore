//
//  PointExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
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

    public func rotatedByAngle(theta: CGFloat, aroundCenter center: CGPoint) -> CGPoint {
        let v = center - self
        let v2 = v.rotatedByAngle(theta)
        let p = center + v2
        return p
    }
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: rhs.x - lhs.x, dy: rhs.y - lhs.y)
}

public func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}
