//
//  ImageUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSImageRenderingMode = UIImageRenderingMode
#elseif os(OSX)
    import Cocoa
    public enum OSImageRenderingMode: Int {
        case Automatic
        case AlwaysOriginal
        case AlwaysTemplate
    }
    extension NSImage {
        var scale: CGFloat { return 1.0 }
    }
#endif

#if os(iOS) || os(tvOS)
public func newImage(withSize size: CGSize, opaque: Bool = false, scale: CGFloat = 0.0, flipped: Bool = false, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = getCurrentGraphicsContext()
    if flipped {
        context.translate(x: 0.0, y: size.height)
        context.scale(x: 1.0, y: -1.0)
    }
    drawing(context)
    let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(renderingMode)
    UIGraphicsEndImageContext()
    return image
}
#elseif os(OSX)
    public func newImage(withSize size: CGSize, opaque: Bool = false, scale: CGFloat = 0.0, flipped: Bool = false, renderingMode: OSImageRenderingMode = .Automatic, drawing: (CGContext) -> Void) -> NSImage {
        let image = NSImage.init(size: size)

        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
                                        pixelsWide: Int(size.width),
                                        pixelsHigh: Int(size.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: opaque ? 3 : 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: NSCalibratedRGBColorSpace,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)

        image.addRepresentation(rep!)
        image.lockFocus()

        let bounds = CGRect(origin: .zero, size: size)
        let context = NSGraphicsContext.currentContext()!.CGContext

        if opaque {
            CGContextSetFillColorWithColor(context, OSColor.Black.CGColor)
            CGContextFillRect(context, bounds)
        } else {
            CGContextClearRect(context, bounds)
        }

        if flipped {
            CGContextTranslateCTM(context, 0.0, size.height)
            CGContextScaleCTM(context, 1.0, -1.0)
        }

        drawing(context)

        image.unlockFocus()
        return image
    }
#endif
