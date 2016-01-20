//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIColor {
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

    public class func diagonalStripesPattern(color1 color1: UIColor, color2: UIColor, flipped: Bool = false) -> UIColor {
        let screenScale = UIScreen.mainScreen().scale
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
        let image = imageWithSize(bounds.size, opaque: true, scale: screenScale, renderingMode: .AlwaysOriginal) { context in
            color1.set(); UIRectFill(bounds)
            let path = UIBezierPath()
            if flipped {
                path.addClosedPolygon([bounds.maxXmidY, bounds.maxXminY, bounds.midXminY])
                path.addClosedPolygon([bounds.maxXmaxY, bounds.minXminY, bounds.minXmidY, bounds.midXmaxY])
            } else {
                path.addClosedPolygon([bounds.midXminY, bounds.minXminY, bounds.minXmidY])
                path.addClosedPolygon([bounds.maxXminY, bounds.minXmaxY, bounds.midXmaxY, bounds.maxXmidY])
            }
            color2.set(); path.fill()
        }
        return UIColor(patternImage: image)
    }

    public func settingSaturation(saturation: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }

    public func settingBrightness(brightness: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }

    public func darkened(frac: Frac) -> UIColor {
        return UIColor(color: color.darkened(frac))
    }

    public func lightened(frac: Frac) -> UIColor {
        return UIColor(color: color.lightened(frac))
    }

    // Identity fraction is 0.0
    public func dodged(frac: Frac) -> UIColor {
        return UIColor(color: color.dodged(frac))
    }

    // Identity fraction is 0.0
    public func burned(frac: Frac) -> UIColor {
        return UIColor(color: color.burned(frac))
    }

    public static var Black:     UIColor { return .blackColor() }
    public static var DarkGray:  UIColor { return .darkGrayColor() }
    public static var LightGray: UIColor { return .lightGrayColor() }
    public static var White:     UIColor { return .whiteColor() }
    public static var Gray:      UIColor { return .grayColor() }
    public static var Red:       UIColor { return .redColor() }
    public static var Green:     UIColor { return .greenColor() }
    public static var Blue:      UIColor { return .blueColor() }
    public static var Cyan:      UIColor { return .cyanColor() }
    public static var Yellow:    UIColor { return .yellowColor() }
    public static var Magenta:   UIColor { return .magentaColor() }
    public static var Orange:    UIColor { return .orangeColor() }
    public static var Purple:    UIColor { return .purpleColor() }
    public static var Brown:     UIColor { return .brownColor() }
    public static var Clear:     UIColor { return .clearColor() }
}

public func testInitColorFromString() {
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
            let color = try UIColor(string: string)
            print("string: \(string), color: \(color)")
        }
    } catch(let error) {
        print("Error: \(error)")
    }
}
