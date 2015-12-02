//
//  VectorExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/4/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension CGVector {
    public init(_ p1: CGPoint, _ p2: CGPoint) {
        dx = p2.x - p1.x
        dy = p2.y - p1.y
    }
    
    public var magnitude: CGFloat {
        return hypot(dx, dy)
    }
    
    public var angle: CGFloat {
        return atan2(dy, dx)
    }
    
    public func normalized() -> CGVector {
        let m = magnitude
        assert(m > 0.0)
        return self / m
    }
    
    public func rotatedByAngle(theta: CGFloat) -> CGVector {
        let sinTheta = sin(theta)
        let cosTheta = cos(theta)
        return CGVector(dx: dx * cosTheta - dy * sinTheta, dy: dx * sinTheta + dy * cosTheta)
    }
    
    public static var unit = CGVector(dx: 1, dy: 0)
}

public func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

public func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

public func dot(v1: CGVector, _ v2: CGVector) -> CGFloat {
    return v1.dx * v2.dx + v1.dy * v2.dy
}

public func cross(v1: CGVector, _ v2: CGVector) -> CGFloat {
    return v1.dx * v2.dy - v1.dy * v2.dx
}
