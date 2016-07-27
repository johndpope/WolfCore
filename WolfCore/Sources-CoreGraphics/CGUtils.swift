//
//  CGUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 5/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import CoreGraphics
#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

public typealias CGContextBlock = (CGContext) -> Void

public func draw(into context: CGContext, drawing: CGContextBlock) {
    context.saveGState()
    drawing(context)
    context.restoreGState()
}

public func drawIntoCurrentContext(drawing: CGContextBlock) {
    draw(into: getCurrentGraphicsContext(), drawing: drawing)
}

public func getCurrentGraphicsContext() -> CGContext {
    #if os(iOS) || os(tvOS)
        return UIGraphicsGetCurrentContext()!
    #elseif os(OSX)
        return NSGraphicsContext.currentContext()!.CGContext
    #endif
}
