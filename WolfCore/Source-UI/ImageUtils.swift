//
//  ImageUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/2/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSImageRenderingMode = UIImageRenderingMode
#elseif os(macOS)
    import Cocoa
    public enum OSImageRenderingMode: Int {
        case automatic
        case alwaysOriginal
        case alwaysTemplate
    }
    extension NSImage {
        var scale: CGFloat { return 1.0 }
    }
#endif

#if os(iOS) || os(tvOS)
    public func newImage(withSize size: CGSize, opaque: Bool = false, background: UIColor? = nil, scale: CGFloat = 0.0, flipped: Bool = false, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock? = nil) -> UIImage {
        guard size.width > 0 && size.height > 0 else {
            fatalError("Size may not be empty.")
        }
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = currentGraphicsContext

        if flipped {
            context.translateBy(x: 0.0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
        }

        if let background = background {
            drawInto(context) { context in
                context.setFillColor(background.cgColor)
                context.fill(CGRect(origin: .zero, size: size))
            }
        }

        drawing?(context)

        let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(renderingMode)
        UIGraphicsEndImageContext()

        return image
    }
#elseif os(macOS)
    public func newImage(withSize size: CGSize, opaque: Bool = false, background: NSColor? = nil, scale: CGFloat = 0.0, flipped: Bool = false, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock? = nil) -> NSImage {
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
        let context = NSGraphicsContext.current()!.cgContext

        if opaque {
            context.setFillColor(OSColor.black.cgColor)
            context.fill(bounds)
        } else {
            context.clear(bounds)
        }

        if flipped {
            context.translateBy(x: 0.0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
        }

        if let background = background {
            drawInto(context) { context in
                context.setFillColor(background.cgColor)
                context.fill(CGRect(origin: .zero, size: size))
            }
        }

        drawing?(context)

        image.unlockFocus()
        return image
    }
#endif
