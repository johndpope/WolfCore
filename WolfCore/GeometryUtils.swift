//
//  GeometryUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public func degreesForRadians(radians: CGFloat) -> CGFloat {
    return CGFloat(Double(radians) / M_PI * 180.0)
}

public func radiansForDegrees(degrees: CGFloat) -> CGFloat {
    return CGFloat(Double(degrees) / 180.0 * M_PI)
}

public func angleOfLineSegment(p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return CGVector(p1, p2).angle
}

public func angleBetweenVectors(v1: CGVector, _ v2: CGVector) -> CGFloat {
    return atan2(cross(v1, v2), dot(v1, v2))
}

public func turningAngleAtVertex(p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
    let v1 = CGVector(p1, p2)
    let v2 = CGVector(p2, p3)
    return angleBetweenVectors(v1, v2)
}

public func meetingAngleAtVertex(p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
    let v1 = CGVector(p1, p2)
    let v2 = CGVector(p3, p2)
    return angleBetweenVectors(v1, v2)
}

public func partingAngleAtVertex(p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> CGFloat {
    let v1 = CGVector(p2, p1)
    let v2 = CGVector(p2, p3)
    return angleBetweenVectors(v1, v2)
}

//
// http://math.stackexchange.com/questions/797828/calculate-center-of-circle-tangent-to-two-lines-in-space
//
public func infoForRoundedCornerArcAtVertexWithRadius(radius radius: CGFloat, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> (center: CGPoint, startPoint: CGPoint, startAngle: CGFloat, endPoint: CGPoint, endAngle: CGFloat, clockwise: Bool) {
    let alpha = partingAngleAtVertex(p1, p2, p3)
    let distanceFromVertexToCenter = radius / (sin(alpha / 2))
    
    let p1p2angle = angleOfLineSegment(p1, p2)
    let bisectionAngle = alpha / 2.0
    let centerAngle = p1p2angle + bisectionAngle
    let center = CGPoint(center: p2, angle: centerAngle, radius: distanceFromVertexToCenter)
    let startAngle: CGFloat = p1p2angle - CGFloat(M_PI / 2)
    let endAngle: CGFloat = angleOfLineSegment(p2, p3) - CGFloat(M_PI / 2)
    let clockwise = true // TODO
    let startPoint = CGPoint(center: center, angle: startAngle, radius: radius)
    let endPoint = CGPoint(center: center, angle: endAngle, radius: radius)
    
    return (center, startPoint, startAngle, endPoint, endAngle, clockwise)
}
