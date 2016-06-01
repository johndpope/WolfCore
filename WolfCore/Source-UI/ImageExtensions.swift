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
    public func tintWithColor(color: OSColor) -> OSImage {
        return newImage(withSize: self.size, opaque: false, scale: self.scale, renderingMode: .AlwaysOriginal) { context in
            let bounds = CGRect(origin: CGPoint.zero, size: self.size)
            self.drawInRect(bounds)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextSetBlendMode(context, .SourceIn)
            CGContextFillRect(context, bounds)
        }
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
