//
//  BezierPathExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSBezierPath = UIBezierPath
#elseif os(macOS)
    import Cocoa
    public typealias OSBezierPath = NSBezierPath
#endif

#if os(macOS)
    extension OSBezierPath {
        public func addLineToPoint(point: CGPoint) {
            line(to: point)
        }

        public func addArcWithCenter(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle)
        }
    }
#endif

extension OSBezierPath {
    public func addClosedPolygon(withPoints points: [CGPoint]) {
        for (index, point) in points.enumerated() {
            switch index {
            case 0:
                move(to: point)
            default:
                addLine(to: point)
            }
        }
        close()
    }

    public convenience init(closedPolygon: [CGPoint]) {
        self.init()
        addClosedPolygon(withPoints: closedPolygon)
    }
}

#if os(macOS)
    extension NSBezierPath {
        public convenience init (arcCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            self.init()
            appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }

        public var CGPath: CGPath {
            let path = CGMutablePath()
            let elementsCount = self.elementCount

            let pointsArray = NSPointArray.allocate( capacity: 3 )

            for index in 0 ..< elementsCount {
                switch element( at: index, associatedPoints: pointsArray ) {
                case NSBezierPathElement.moveToBezierPathElement:
                    CGPathMoveToPoint( path, nil, pointsArray[0].x, pointsArray[0].y )

                case NSBezierPathElement.lineToBezierPathElement:
                    CGPathAddLineToPoint( path, nil, pointsArray[0].x, pointsArray[0].y )

                case NSBezierPathElement.curveToBezierPathElement:
                    CGPathAddCurveToPoint( path, nil, pointsArray[0].x, pointsArray[0].y,
                                           pointsArray[1].x, pointsArray[1].y,
                                           pointsArray[2].x, pointsArray[2].y )

                case NSBezierPathElement.closePathBezierPathElement:
                    path.closeSubpath()
                }
            }

            return path.copy()!
        }
    }
#endif

extension OSBezierPath {
    public convenience init(sides: Int, radius: CGFloat, center: CGPoint = .zero, rotationAngle: CGFloat = 0.0, cornerRadius: CGFloat = 0.0) {

        self.init()

        let theta = 2 * .pi / Double(sides)
        let r = Double(radius)

        var corners = [CGPoint]()
        for side in 0 ..< sides {
            let alpha = Double(side) * theta + Double(rotationAngle)
            let cornerX = cos(alpha) * r + Double(center.x)
            let cornerY = sin(alpha) * r + Double(center.y)
            let corner = CGPoint(x: cornerX, y: cornerY)
            corners.append(corner)
        }

        if cornerRadius <= 0.0 {
            for (index, corner) in corners.enumerated() {
                if index == 0 {
                    move(to: corner)
                } else {
                    addLine(to: corner)
                }
            }
        } else {
            for index in 0..<corners.count {
                let p1 = Point(cgPoint: corners.element(atCircularIndex: index - 1))
                let p2 = Point(cgPoint: corners[index])
                let p3 = Point(cgPoint: corners.element(atCircularIndex: index + 1))
                let (center, startPoint, startAngle, _ /*endPoint*/, endAngle, clockwise) = infoForRoundedCornerArcAtVertex(withRadius: Double(cornerRadius), p1, p2, p3)
                if index == 0 {
                    move(to: startPoint.cgPoint)
                }
                addArc(withCenter: center.cgPoint, radius: cornerRadius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise)
            }
        }
        close()
    }
}
