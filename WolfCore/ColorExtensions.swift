//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

// #abc
//
// ^\s*#(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\s*$
private let singleHexColorRegex = try! ~/"^\\s*#(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\\s*$"

// #aabbcc
//
// ^\s*#(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\s*$
private let doubleHexColorRegex = try! ~/"^\\s*#(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\\s*$"

// 1 0 0
// 1 0 0 1
// 1.0 0.0 0.0
// 1.0 0.0 0.0 1.0
// .2 .3 .4 .5
//
// ^\s*(?<r>\d*(?:\.\d+)?)\s+(?<g>\d*(?:\.\d+)?)\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?<a>\d*(?:\.\d+)?))?\s*$
private let floatColorRegex = try! ~/"^\\s*(?<r>\\d*(?:\\.\\d+)?)\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?<a>\\d*(?:\\.\\d+)?))?\\s*$"

// r: .1 g: 0.512 b: 0.9
// r: .1 g: 0.512 b: 0.9 a: 1
// red: .1 green: 0.512 blue: 0.9
// red: .1 green: 0.512 blue: 0.9 alpha: 1
//
// ^\s*(?:r(?:ed)?):\s+(?<r>\d*(?:\.\d+)?)\s+(?:g(?:reen)?):\s+(?<g>\d*(?:\.\d+)?)\s+(?:b(?:lue)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
private let labeledColorRegex = try! ~/"^\\s*(?:r(?:ed)?):\\s+(?<r>\\d*(?:\\.\\d+)?)\\s+(?:g(?:reen)?):\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?:b(?:lue)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?"

// h: .1 s: 0.512 b: 0.9
// hue: .1 saturation: 0.512 brightness: 0.9
// h: .1 s: 0.512 b: 0.9 alpha: 1
// hue: .1 saturation: 0.512 brightness: 0.9 alpha: 1.0
//
// ^\s*(?:h(?:ue)?):\s+(?<h>\d*(?:\.\d+)?)\s+(?:s(?:aturation)?):\s+(?<s>\d*(?:\.\d+)?)\s+(?:b(?:rightness)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
private let labeledHSBColorRegex = try! ~/"^\\s*(?:h(?:ue)?):\\s+(?<h>\\d*(?:\\.\\d+)?)\\s+(?:s(?:aturation)?):\\s+(?<s>\\d*(?:\\.\\d+)?)\\s+(?:b(?:rightness)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?"

extension UIColor {
    public convenience init(color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
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
    
    public convenience init(string s: String) throws {
        var components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        var isHSB = false
        
        if let strings = singleHexColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let i = Int(string, radix: 16) {
                    components[index] = CGFloat(i) / 15.0
                }
            }
        } else if let strings = doubleHexColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let i = Int(string, radix: 16) {
                    components[index] = CGFloat(i) / 255.0
                }
            }
        } else if let strings = floatColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let f = Double(string) {
                    components[index] = CGFloat(f)
                }
            }
        } else if let strings = labeledColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let f = Double(string) {
                    components[index] = CGFloat(f)
                }
            }
        } else if let strings = labeledHSBColorRegex.matchedSubstringsInString(s) {
            isHSB = true
            for (index, string) in strings.enumerate() {
                if let f = Double(string) {
                    components[index] = CGFloat(f)
                }
            }
        } else {
            throw GeneralError(message: "Could not parse color from string: \(s)")
        }
        
        if isHSB {
            self.init(hue: components[0], saturation: components[1], brightness: components[2], alpha: components[3])
        } else {
            self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        }
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
