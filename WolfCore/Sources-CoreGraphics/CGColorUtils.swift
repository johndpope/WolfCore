//
//  CGColorUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 1/10/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(macOS)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

import CoreGraphics

public var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
public var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
public var sharedWhiteColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(1.0), CGFloat(1.0)])
public var sharedBlackColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(1.0)])
public var sharedClearColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(0.0)])

extension CGColor {
    public func toRGB() -> CGColor {
        switch colorSpace!.model {
        case CGColorSpaceModel.monochrome:
            let c = components!
            let gray = c[0]
            let a = c[1]
            return CGColor(colorSpace: sharedColorSpaceRGB, components: [gray, gray, gray, a])!
        case CGColorSpaceModel.rgb:
            return self
        default:
            fatalError("unsupported color model")
        }
    }
}

public func CGGradientWithColors(colorFracs: [ColorFrac]) -> CGGradient {
    var cgColors = [CGColor]()
    var locations = [CGFloat]()
    for colorFrac in colorFracs {
        cgColors.append(colorFrac.color.cgColor)
        locations.append(CGFloat(colorFrac.frac))
    }
    return CGGradient(colorsSpace: sharedColorSpaceRGB, colors: cgColors as CFArray, locations: locations)!
}
