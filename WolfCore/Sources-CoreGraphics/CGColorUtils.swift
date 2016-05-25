//
//  CGColorUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 1/10/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(OSX)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

import CoreGraphics

public var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
public var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
public var sharedWhiteColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(1.0), CGFloat(1.0)])
public var sharedBlackColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(0.0), CGFloat(1.0)])
public var sharedClearColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(0.0), CGFloat(0.0)])

public func CGColorWithColor(color: Color) -> CGColor {
    let red = CGFloat(color.red)
    let green = CGFloat(color.green)
    let blue = CGFloat(color.blue)
    let alpha = CGFloat(color.alpha)
    return CGColorCreate(sharedColorSpaceRGB, [red, green, blue, alpha])!
}

public func ColorWithCGColor(cgColor: CGColor) -> Color {
    let oldc = CGColorGetComponents(cgColor)

    switch CGColorSpaceGetModel(CGColorGetColorSpace(cgColor)) {
    case .Monochrome:
        let white = Double(oldc[0])
        let alpha = Double(oldc[1])
        return Color(white: white, alpha: alpha)
    case .RGB:
        let red = Double(oldc[0])
        let green = Double(oldc[1])
        let blue = Double(oldc[2])
        let alpha = Double(oldc[3])
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    default:
        fatalError("unsupported color model")
    }
}

public func CGColorCreateByDarkening(color color: CGColor, frac: Frac) -> CGColor {
    return CGColorWithColor(ColorWithCGColor(color).darkened(frac))
}

public func CGColorCreateByLightening(color color: CGColor, frac: Frac) -> CGColor {
    return CGColorWithColor(ColorWithCGColor(color).lightened(frac))
}

// Identity fraction is 0.0
public func CGColorCreateByDodging(color color: CGColor, frac: Frac) -> CGColor {
    return CGColorWithColor(ColorWithCGColor(color).dodged(frac))
}

// Identity fraction is 0.0
public func CGColorCreateByBurning(color color: CGColor, frac: Frac) -> CGColor {
    return CGColorWithColor(ColorWithCGColor(color).burned(frac))
}

public func CGColorCreateByInterpolating(color1 color1: CGColor, color2: CGColor, frac: CGFloat) -> CGColor! {
    var result: CGColor? = nil

    let oldc1 = CGColorGetComponents(color1)
    let oldc2 = CGColorGetComponents(color2)

    let colorSpaceModel1 = CGColorSpaceGetModel(CGColorGetColorSpace(color1))
    let colorSpaceModel2 = CGColorSpaceGetModel(CGColorGetColorSpace(color2))

    if colorSpaceModel1 == colorSpaceModel2 {
        switch colorSpaceModel1 {
        case .Monochrome:
            let gray = Math.interpolate(frac, oldc1[0], oldc2[0])
            let a = oldc1[1]
            result = CGColorCreate(sharedColorSpaceGray, [gray, a])
        case .RGB:
            let r = Math.interpolate(frac, oldc1[0], oldc2[0])
            let g = Math.interpolate(frac, oldc1[1], oldc2[1])
            let b = Math.interpolate(frac, oldc1[2], oldc2[2])
            let a = oldc1[3]
            result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
        default:
            fatalError("unsupported color model")
        }
    } else {
        fatalError("color space mismatch")
    }

    return result
}

public func CGColorCreate(r r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> CGColor {
    return CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])!
}

public func CGColorCreate(gray gray: CGFloat, a: CGFloat) -> CGColor {
    return CGColorCreate(sharedColorSpaceGray, [gray, a])!
}

public func CGColorCreateRandom(random: Random = Random.sharedInstance) -> CGColor {
    var components = Array(count: 4, repeatedValue: CGFloat(0))
    for i in 0 ..< 3 {
        components[i] = random.randomCGFloat()
    }
    components[3] = 1
    return CGColorCreate(sharedColorSpaceRGB, components)!
}

public func CGColorConvertToRGB(color: CGColor) -> CGColor {
    var result: CGColor! = color

    let oldc = CGColorGetComponents(color)

    switch CGColorSpaceGetModel(CGColorGetColorSpace(color)) {
    case .Monochrome:
        let gray = oldc[0]
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceRGB, [gray, gray, gray, a])!
    case .RGB:
        break
    default:
        fatalError("unsupported color model")
    }

    return result
}

public func CGGradientWithColors(colorFracs: [ColorFrac]) -> CGGradient {
    var cgColors = [CGColor]()
    var locations = [CGFloat]()
    for colorFrac in colorFracs {
        cgColors.append(colorFrac.color.cgColor)
        locations.append(CGFloat(colorFrac.frac))
    }
    return CGGradientCreateWithColors(sharedColorSpaceRGB, cgColors, locations)!
}
