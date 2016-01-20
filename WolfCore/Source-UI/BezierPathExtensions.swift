//
//  BezierPathExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIBezierPath {
    public func addClosedPolygon(points: [CGPoint]) {
        for (index, point) in points.enumerate() {
            switch index {
            case 0:
                moveToPoint(point)
            default:
                addLineToPoint(point)
            }
        }
        closePath()
    }
    
    public convenience init(closedPolygon: [CGPoint]) {
        self.init()
        addClosedPolygon(closedPolygon)
    }
}

extension UIBezierPath {
    public convenience init(sides: Int, radius: CGFloat, center: CGPoint = .zero, rotationAngle: CGFloat = 0.0, cornerRadius: CGFloat = 0.0) {
        let theta = 2 * M_PI / Double(sides)
        let r = Double(radius)

        var corners = [CGPoint]()
        for var side = 0; side < sides; ++side {
            let alpha = Double(side) * theta + Double(rotationAngle)
            let cornerX = cos(alpha) * r + Double(center.x)
            let cornerY = sin(alpha) * r + Double(center.y)
            let corner = CGPoint(x: cornerX, y: cornerY)
            corners.append(corner)
        }
        
        let path = UIBezierPath()
        if cornerRadius <= 0.0 {
            for (index, corner) in corners.enumerate() {
                if index == 0 {
                    path.moveToPoint(corner)
                } else {
                    path.addLineToPoint(corner)
                }
            }
        } else {
            for index in 0..<corners.count {
                let p1 = Point(cgPoint: corners.elementAtCircularIndex(index - 1))
                let p2 = Point(cgPoint: corners[index])
                let p3 = Point(cgPoint: corners.elementAtCircularIndex(index + 1))
                let (center, startPoint, startAngle, _ /*endPoint*/, endAngle, clockwise) = infoForRoundedCornerArcAtVertexWithRadius(radius: Double(cornerRadius), p1, p2, p3)
                if index == 0 {
                    path.moveToPoint(startPoint.cgPoint)
                }
                path.addArcWithCenter(center.cgPoint, radius: cornerRadius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise)
            }
        }
        path.closePath()
        
        self.init(CGPath: path.CGPath)
    }
}
