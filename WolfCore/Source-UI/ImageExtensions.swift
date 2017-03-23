//
//  ImageExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSImage = UIImage
#elseif os(macOS)
    import Cocoa
    public typealias OSImage = NSImage
    extension NSImage {
        public var cgImage: CGImage! {
            return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
        }
    }
#endif

import CoreGraphics
import CoreImage

public typealias ImageBlock = (OSImage) -> Void

extension OSImage {
    public var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}

extension OSImage {
    public func desaturated(saturation: Double = 0.0, brightness: Double = 0.0, contrast: Double = 1.1, exposureAdjust: Double = 0.7) -> OSImage {
        return self
            |> ColorControlsFilter(saturation: saturation, brightness: brightness, contrast: contrast)
            |> ExposureAdjustFilter(ev: exposureAdjust)
            |> (imageOrientation, self.scale)
    }

    public func blurred(radius: Double = 5.0) -> OSImage {
        return self
            |> BlurFilter(radius: radius)
            |> (imageOrientation, self.scale)
    }
}

extension OSImage {
    public func tinted(withColor color: OSColor) -> OSImage {
        return newImage(withSize: self.size, opaque: false, scale: self.scale, renderingMode: .alwaysOriginal) { context in
            self.draw(in: self.bounds)
            context.setFillColor(color.cgColor)
            context.setBlendMode(.sourceIn)
            context.fill(self.bounds)
        }
    }

    public func shaded(withColor color: OSColor, blendMode: CGBlendMode = .multiply) -> OSImage {
        return newImage(withSize: size, opaque: false, scale: scale, flipped: true, renderingMode: .alwaysOriginal) { context in
            drawInto(context) { context in
                context.clip(to: self.bounds, mask: self.cgImage!)
                context.setFillColor(color.cgColor)
                context.fill(self.bounds)
            }
            context.setBlendMode(blendMode)
            context.draw(self.cgImage!, in: self.bounds)
        }
    }

    public func dodged(withColor color: OSColor) -> OSImage {
        return shaded(withColor: color, blendMode: .colorDodge)
    }

    public convenience init(size: CGSize, color: OSColor, opaque: Bool = false, scale: CGFloat = 0.0) {
        let image = newImage(withSize: size, opaque: opaque, scale: scale, renderingMode: .alwaysOriginal) { context in
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
        #if os(macOS)
            self.init(cgImage: image.cgImage!, scale: scale, size: image.size)
        #else
            self.init(cgImage: image.cgImage!, scale: scale, orientation: .up)
        #endif
    }

    public func composited(over backgroundImage: UIImage) -> UIImage {
        let backgroundBounds = CGRect(origin: .zero, size: backgroundImage.size)
        let foregroundBounds = CGRect(origin: .zero, size: self.size)

        return newImage(withSize: backgroundBounds.size, opaque: false, scale: backgroundImage.scale, renderingMode: .alwaysOriginal) { context in
            backgroundImage.draw(in: backgroundBounds)
            self.draw(in: foregroundBounds)
        }
    }

    public func masked(with path: UIBezierPath) -> UIImage {
        return newImage(withSize: size, opaque: false, scale: scale, renderingMode: renderingMode) { context in
            context.addPath(path.cgPath)
            context.clip()
            self.draw(in: self.bounds)
        }
    }

    public func maskedWithCircle() -> UIImage {
        return masked(with: UIBezierPath(ovalIn: bounds))
    }

    public func scaled(toSize size: CGSize, opaque: Bool = false) -> OSImage {
        let targetSize = self.size.aspectFit(within: size)
        return newImage(withSize: targetSize, opaque: opaque, scale: scale, renderingMode: self.renderingMode) { context in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    public func cropped(toRect rect: CGRect, opaque: Bool = false) -> OSImage {
        return newImage(withSize: rect.size, opaque: opaque, scale: scale, renderingMode: self.renderingMode) { context in
            self.draw(in: CGRect(x: -rect.minX, y: -rect.minY, width: rect.width, height: rect.height))
        }
    }

    public func scaledDownAndCroppedToSquare(withMaxSize maxSize: CGFloat) -> OSImage {
        let scale = min(size.scaleForAspectFill(within: CGSize(width: maxSize, height: maxSize)), 1.0)
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
    public convenience init?(named name: String, in bundle: Bundle?) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
    #elseif os(macOS)
    public convenience init?(named name: String, in bundle: Bundle?) {
        let bundle = bundle ?? Bundle.main
        guard let image = bundle.image(forResource: name) else {
            return nil
        }
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        self.init(cgImage: cgImage, size: image.size)
    }
    #endif
}

// Support the Serializable protocol used for caching

extension OSImage: Serializable {
    public typealias ValueType = OSImage

    public func serialize() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    public static func deserialize(from data: Data) throws -> OSImage {
        if let image = NSKeyedUnarchiver.unarchiveObject(with: data) as? OSImage {
            return image
        } else {
            throw ValidationError(message: "Invalid image data.", violation: "imageFormat")
        }
    }
}

public struct ImageReference: ExtensibleEnumeratedName, Reference {
    public let name: String
    public let bundle: Bundle

    public init(_ name: String, inBundle bundle: Bundle? = nil) {
        self.name = name
        self.bundle = bundle ?? Bundle.main
    }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }

    // Reference
    public var referent: OSImage {
        return OSImage(named: name, in: bundle)!
    }
}

public postfix func ® (lhs: ImageReference) -> OSImage {
    return lhs.referent
}
