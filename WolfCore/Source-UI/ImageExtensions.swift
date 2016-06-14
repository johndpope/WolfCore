//
//  ImageExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSImage = UIImage
#elseif os(OSX)
    import Cocoa
    public typealias OSImage = NSImage
#endif

extension OSImage {
    public var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}

extension OSImage {
    public func tinted(withColor color: OSColor) -> OSImage {
        return newImage(withSize: self.size, opaque: false, scale: self.scale, renderingMode: .AlwaysOriginal) { context in
            let bounds = CGRect(origin: CGPoint.zero, size: self.size)
            self.drawInRect(bounds)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextSetBlendMode(context, .SourceIn)
            CGContextFillRect(context, bounds)
        }
    }

    public convenience init(size: CGSize, color: UIColor, opaque: Bool = false, scale: CGFloat = 0.0) {
        let image = newImage(withSize: size, opaque: opaque, scale: scale) { context in
            let bounds = CGRect(origin: CGPoint.zero, size: size)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, bounds)
        }
        self.init(CGImage: image.CGImage!)
    }

    public func scaled(toSize size: CGSize, opaque: Bool = false) -> OSImage {
        return newImage(withSize: size, opaque: opaque, scale: scale) { context in
            self.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }

    public func cropped(toRect rect: CGRect, opaque: Bool = false) -> OSImage {
        return newImage(withSize: rect.size, opaque: opaque, scale: scale) { context in
            self.drawInRect(CGRect(x: -rect.minX, y: -rect.minY, width: rect.width, height: rect.height))
        }
    }

    public func scaledDownAndCroppedToSquare(withMaxSize maxSize: CGFloat) -> OSImage {
        let scale = min(size.scaleForAspectFillWithinSize(CGSize(width: maxSize, height: maxSize)), 1.0)
        let scaledImage: OSImage
        if scale < 1.0 {
            let scaledSize = CGSize(vector: CGVector(size: size) * scale)
            scaledImage = scaled(toSize: scaledSize)
        } else {
            scaledImage = self
        }

        let length = min(scaledImage.size.width, scaledImage.size.height)
        let croppedSize = CGSize(width: length, height: length)
        let croppedImage: OSImage
        if croppedSize != scaledImage.size {
            let cropRect = CGRect(origin: .zero, size: croppedSize).settingMidXmidY(scaledImage.bounds.midXmidY)
            croppedImage = scaledImage.cropped(toRect: cropRect)
        } else {
            croppedImage = scaledImage
        }
        return croppedImage
    }

    #if os(iOS)
    public convenience init?(named name: String, fromBundleForClass aClass: AnyClass?, compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) {
        let bundle = NSBundle.findBundle(forClass: aClass)
        self.init(named: name, inBundle: bundle, compatibleWithTraitCollection: traitCollection)
    }
    #elseif os(OSX)
    public convenience init?(named name: String, fromBundleForClass aClass: AnyClass?) {
        let bundle = NSBundle.findBundle(forClass: aClass)
        guard let image = bundle.imageForResource(name) else {
            return nil
        }
        guard let cgImage = image.CGImageForProposedRect(nil, context: nil, hints: nil) else {
            return nil
        }
        self.init(CGImage: cgImage, size: image.size)
    }
    #endif
}
