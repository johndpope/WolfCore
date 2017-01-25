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
#elseif os(macOS)
    import Cocoa
#endif

public typealias CGContextBlock = (CGContext) -> Void

public func drawInto(_ context: CGContext, drawing: CGContextBlock) {
    context.saveGState()
    drawing(context)
    context.restoreGState()
}

public func drawIntoCurrentContext(drawing: CGContextBlock) {
    drawInto(currentGraphicsContext, drawing: drawing)
}

public var currentGraphicsContext: CGContext {
    #if os(iOS) || os(tvOS)
        return UIGraphicsGetCurrentContext()!
    #elseif os(macOS)
        return NSGraphicsContext.current()!.cgContext
    #endif
}
