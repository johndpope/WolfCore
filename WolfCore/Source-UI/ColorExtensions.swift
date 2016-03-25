//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias OSColor = UIColor
#else
    import Cocoa
    public typealias OSColor = NSColor
#endif

extension OSColor {
    public convenience init(color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }

    public convenience init(string: String) throws {
        self.init(color: try Color(string: string))
    }

    public var color: Color {
        return ColorWithCGColor(CGColor)
    }

    // NOTE: Not gamma-corrected
    public var luminance: CGFloat {
        return CGFloat(color.luminance)
    }

    public class func diagonalStripesPattern(color1 color1: OSColor, color2: OSColor, flipped: Bool = false) -> OSColor {
        #if os(iOS)
            let screenScale = UIScreen.mainScreen().scale
        #elseif os(OSX)
            let screenScale: CGFloat = 1.0
        #endif
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
        let image = newImage(withSize: bounds.size, opaque: true, scale: screenScale, renderingMode: .AlwaysOriginal) { context in
            CGContextSetFillColorWithColor(context, color1.CGColor)
            CGContextFillRect(context, bounds)
            let path = OSBezierPath()
            if flipped {
                path.addClosedPolygon([bounds.maxXmidY, bounds.maxXminY, bounds.midXminY])
                path.addClosedPolygon([bounds.maxXmaxY, bounds.minXminY, bounds.minXmidY, bounds.midXmaxY])
            } else {
                path.addClosedPolygon([bounds.midXminY, bounds.minXminY, bounds.minXmidY])
                path.addClosedPolygon([bounds.maxXminY, bounds.minXmaxY, bounds.midXmaxY, bounds.maxXmidY])
            }
            color2.set(); path.fill()
        }
        return OSColor(patternImage: image)
    }

    public func settingSaturation(saturation: CGFloat) -> OSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return OSColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }

    public func settingBrightness(brightness: CGFloat) -> OSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return OSColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }

    public func darkened(frac: Frac) -> OSColor {
        return OSColor(color: color.darkened(frac))
    }

    public func lightened(frac: Frac) -> OSColor {
        return OSColor(color: color.lightened(frac))
    }

    // Identity fraction is 0.0
    public func dodged(frac: Frac) -> OSColor {
        return OSColor(color: color.dodged(frac))
    }

    // Identity fraction is 0.0
    public func burned(frac: Frac) -> OSColor {
        return OSColor(color: color.burned(frac))
    }

    public static var Black:     OSColor { return .blackColor() }
    public static var DarkGray:  OSColor { return .darkGrayColor() }
    public static var LightGray: OSColor { return .lightGrayColor() }
    public static var White:     OSColor { return .whiteColor() }
    public static var Gray:      OSColor { return .grayColor() }
    public static var Red:       OSColor { return .redColor() }
    public static var Green:     OSColor { return .greenColor() }
    public static var Blue:      OSColor { return .blueColor() }
    public static var Cyan:      OSColor { return .cyanColor() }
    public static var Yellow:    OSColor { return .yellowColor() }
    public static var Magenta:   OSColor { return .magentaColor() }
    public static var Orange:    OSColor { return .orangeColor() }
    public static var Purple:    OSColor { return .purpleColor() }
    public static var Brown:     OSColor { return .brownColor() }
    public static var Clear:     OSColor { return .clearColor() }
}

extension OSColor {
    public static func testInitFromString() {
        do {
            let strings = [
                "#f80",
                "#ff8000",
                "0.1 0.5 1.0",
                "0.1 0.5 1.0 0.5",
                "r: 0.2 g: 0.4 b: 0.6",
                "red: 0.3 green: 0.5 blue: 0.7",
                "red: 0.3 green: 0.5 blue: 0.7 alpha: 0.5",
                "h: 0.2 s: 0.8 b: 1.0",
                "hue: 0.2 saturation: 0.8 brightness: 1.0",
                "hue: 0.2 saturation: 0.8 brightness: 1.0 alpha: 0.5",
            ]
            for string in strings {
                let color = try OSColor(string: string)
                print("string: \(string), color: \(color)")
            }
        } catch(let error) {
            logError(error)
        }
    }
}