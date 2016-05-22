//
//  BezierPathExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSBezierPath = UIBezierPath
#elseif os(OSX)
    import Cocoa
    public typealias OSBezierPath = NSBezierPath
#endif

#if os(OSX)
    extension OSBezierPath {
        public func addLineToPoint(point: CGPoint) {
            lineToPoint(point)
        }
        
        public func addArcWithCenter(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            appendBezierPathWithArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle)
        }
    }
#endif

extension OSBezierPath {
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

#if os(OSX)
    extension NSBezierPath
    {
        public convenience init (arcCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            self.init()
            appendBezierPathWithArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }

        public var CGPath: CGPathRef
        {
            let path = CGPathCreateMutable()
            let elementsCount = self.elementCount
            
            let pointsArray = NSPointArray.alloc( 3 )
            
            for index in 0 ..< elementsCount
            {
                switch elementAtIndex( index, associatedPoints: pointsArray )
                {
                case NSBezierPathElement.MoveToBezierPathElement:
                    CGPathMoveToPoint( path, nil, pointsArray[0].x, pointsArray[0].y )
                    
                case NSBezierPathElement.LineToBezierPathElement:
                    CGPathAddLineToPoint( path, nil, pointsArray[0].x, pointsArray[0].y )
                    
                case NSBezierPathElement.CurveToBezierPathElement:
                    CGPathAddCurveToPoint( path, nil, pointsArray[0].x, pointsArray[0].y,
                                           pointsArray[1].x, pointsArray[1].y,
                                           pointsArray[2].x, pointsArray[2].y )
                    
                case NSBezierPathElement.ClosePathBezierPathElement:
                    CGPathCloseSubpath( path )
                }
            }
            
            return CGPathCreateCopy( path )!
        }
    }
#endif

extension OSBezierPath {
    public convenience init(sides: Int, radius: CGFloat, center: CGPoint = .zero, rotationAngle: CGFloat = 0.0, cornerRadius: CGFloat = 0.0) {
        
        self.init()
        
        let theta = 2 * M_PI / Double(sides)
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
            for (index, corner) in corners.enumerate() {
                if index == 0 {
                    moveToPoint(corner)
                } else {
                    addLineToPoint(corner)
                }
            }
        } else {
            for index in 0..<corners.count {
                let p1 = Point(cgPoint: corners.elementAtCircularIndex(index - 1))
                let p2 = Point(cgPoint: corners[index])
                let p3 = Point(cgPoint: corners.elementAtCircularIndex(index + 1))
                let (center, startPoint, startAngle, _ /*endPoint*/, endAngle, clockwise) = infoForRoundedCornerArcAtVertex(withRadius: Double(cornerRadius), p1, p2, p3)
                if index == 0 {
                    moveToPoint(startPoint.cgPoint)
                }
                addArcWithCenter(center.cgPoint, radius: cornerRadius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise)
            }
        }
        closePath()
    }
}
