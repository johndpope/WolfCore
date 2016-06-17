//
//  GeometryUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public func degrees(forRadians radians: Double) -> Double {
    return radians / .pi * 180.0
}

public func radians(forDegrees degrees: Double) -> Double {
    return degrees / 180.0 * .pi
}

public func angleOfLineSegment(_ p1: Point, _ p2: Point) -> Double {
    return Vector(p1, p2).angle
}

public func angleBetweenVectors(_ v1: Vector, _ v2: Vector) -> Double {
    return atan2(cross(v1, v2), dot(v1, v2))
}

public func turningAngleAtVertex(_ p1: Point, _ p2: Point, _ p3: Point) -> Double {
    let v1 = Vector(p1, p2)
    let v2 = Vector(p2, p3)
    return angleBetweenVectors(v1, v2)
}

public func meetingAngleAtVertex(_ p1: Point, _ p2: Point, _ p3: Point) -> Double {
    let v1 = Vector(p1, p2)
    let v2 = Vector(p3, p2)
    return angleBetweenVectors(v1, v2)
}

public func partingAngleAtVertex(_ p1: Point, _ p2: Point, _ p3: Point) -> Double {
    let v1 = Vector(p2, p1)
    let v2 = Vector(p2, p3)
    return angleBetweenVectors(v1, v2)
}

//
// http://math.stackexchange.com/questions/797828/calculate-center-of-circle-tangent-to-two-lines-in-space
//
public func infoForRoundedCornerArcAtVertex(withRadius radius: Double, _ p1: Point, _ p2: Point, _ p3: Point) -> (center: Point, startPoint: Point, startAngle: Double, endPoint: Point, endAngle: Double, clockwise: Bool) {
    let alpha = partingAngleAtVertex(p1, p2, p3)
    let distanceFromVertexToCenter = radius / (sin(alpha / 2))

    let p1p2angle = angleOfLineSegment(p1, p2)
    let bisectionAngle = alpha / 2.0
    let centerAngle = p1p2angle + bisectionAngle
    let center = Point(center: p2, angle: centerAngle, radius: distanceFromVertexToCenter)
    let startAngle = p1p2angle - .pi / 2
    let endAngle = angleOfLineSegment(p2, p3) - .pi / 2
    let clockwise = true // TODO
    let startPoint = Point(center: center, angle: startAngle, radius: radius)
    let endPoint = Point(center: center, angle: endAngle, radius: radius)

    return (center, startPoint, startAngle, endPoint, endAngle, clockwise)
}
