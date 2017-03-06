//
//  CGColorUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/10/16.
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

extension CGGradient {
    public static func new(with colorFracs: [ColorFrac]) -> CGGradient {
        var cgColors = [CGColor]()
        var locations = [CGFloat]()
        for colorFrac in colorFracs {
            cgColors.append(colorFrac.color.cgColor)
            locations.append(CGFloat(colorFrac.frac))
        }
        return CGGradient(colorsSpace: sharedColorSpaceRGB, colors: cgColors as CFArray, locations: locations)!
    }

    public static func new(from color1: Color, to color2: Color) -> CGGradient {
        return new(with: [(color: color1, frac: 0.0), (color: color2, frac: 1.0)])
    }

    public static func new(from color1: UIColor, to color2: UIColor) -> CGGradient {
        return new(from: color1 |> Color.init, to: color2 |> Color.init)
    }
}
