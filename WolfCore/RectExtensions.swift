//
//  RectExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension CGRect {
    // Corners
    public var minXminY: CGPoint { return CGPoint(x: minX, y: minY) }
    public var maxXminY: CGPoint { return CGPoint(x: maxX, y: minY) }
    public var maxXmaxY: CGPoint { return CGPoint(x: maxX, y: maxY) }
    public var minXmaxY: CGPoint { return CGPoint(x: minX, y: maxY) }
    
    // Sides
    public var midXminY: CGPoint { return CGPoint(x: midX, y: minY) }
    public var midXmaxY: CGPoint { return CGPoint(x: midX, y: maxY) }
    public var maxXmidY: CGPoint { return CGPoint(x: maxX, y: midY) }
    public var minXmidY: CGPoint { return CGPoint(x: minX, y: midY) }
    
    // Center
    public var midXmidY: CGPoint { return CGPoint(x: midX, y: midY) }
}
