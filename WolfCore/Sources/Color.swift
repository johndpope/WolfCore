//
//  Color.swift
//  WolfCore
//
//  Created by Robert McNally on 1/10/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import Glibc
#endif

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

public struct Color {
    public let red: Frac
    public let green: Frac
    public let blue: Frac
    public let alpha: Frac

    public init(red: Frac, green: Frac, blue: Frac, alpha: Frac = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(redByte: Byte, greenByte: Byte, blueByte: Byte, alphaByte: Byte = 255) {
        self.init(red: Double(redByte) / 255.0,
            green: Double(greenByte) / 255.0,
            blue: Double(blueByte) / 255.0,
            alpha: Double(alphaByte) / 255.0
        )
    }

    public init(white: Frac, alpha: Frac = 1.0) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }

    public init(bytes: Bytes) {
        let redByte = bytes[0]
        let greenByte = bytes[1]
        let blueByte = bytes[2]
        let alphaByte = bytes.count >= 4 ? bytes[3] : 255
        self.init(redByte: redByte, greenByte: greenByte, blueByte: blueByte, alphaByte: alphaByte)
    }

    public init(color: Color, alpha: Frac) {
        self.red = color.red
        self.green = color.green
        self.blue = color.blue
        self.alpha = alpha
    }

    public init(hue h: Frac, saturation s: Frac, brightness v: Frac, alpha a: Frac = 1.0) {
        let v = Math.clamp(v, 0.0...1.0)
        let s = Math.clamp(s, 0.0...1.0)
        alpha = a
        if(s <= 0.0) {
            red = v
            green = v
            blue = v
        } else {
            var h = h % 1.0
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floor(h))
            let f = h - Double(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch(i) {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: red = 0; green = 0; blue = 0; assert(false, "unknown hue sector")
            }
        }
    }

    public init(string s: String) throws {
        var components: [Double] = [0.0, 0.0, 0.0, 1.0]
        var isHSB = false

        if let strings = singleHexColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let i = Int(string, radix: 16) {
                    components[index] = Double(i) / 15.0
                }
            }
        } else if let strings = doubleHexColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let i = Int(string, radix: 16) {
                    components[index] = Double(i) / 255.0
                }
            }
        } else if let strings = floatColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let f = Double(string) {
                    components[index] = Double(f)
                }
            }
        } else if let strings = labeledColorRegex.matchedSubstringsInString(s) {
            for (index, string) in strings.enumerate() {
                if let f = Double(string) {
                    components[index] = Double(f)
                }
            }
        } else if let strings = labeledHSBColorRegex.matchedSubstringsInString(s) {
            isHSB = true
            for (index, string) in strings.enumerate() {
                if let f = Double(string) {
                    components[index] = Double(f)
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

    public static func randomColor(random: Random = Random.sharedInstance, alpha: Frac = 1.0) -> Color {
        return Color(
            red: random.randomDouble(),
            green: random.randomDouble(),
            blue: random.randomDouble(),
            alpha: alpha
        )
    }

    // NOTE: Not gamma-corrected
    public var luminance: Frac {
        return red * 0.2126 + green * 0.7152 + blue * 0.0722
    }

    public func multipliedBy(rhs: Frac) -> Color {
        return Color(red: red * rhs, green: green * rhs, blue: blue * rhs, alpha: alpha * rhs)
    }

    public func addedTo(rhs: Color) -> Color {
        return Color(red: red + rhs.red, green: green + rhs.green, blue: blue + rhs.blue, alpha: alpha + rhs.alpha)
    }

    public func lightened(frac: Frac) -> Color {
        return Color(
            red: Math.denormalize(frac, red, 1),
            green: Math.denormalize(frac, green, 1),
            blue: Math.denormalize(frac, blue, 1),
            alpha: alpha)
    }

    public func darkened(frac: Frac) -> Color {
        return Color(
            red: Math.denormalize(frac, red, 0),
            green: Math.denormalize(frac, green, 0),
            blue: Math.denormalize(frac, blue, 0),
            alpha: alpha)
    }

    // Identity fraction is 0.0
    public func dodged(frac: Frac) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(red / f, 1.0),
            green: min(green / f, 1.0),
            blue: min(blue / f, 1.0),
            alpha: alpha)
    }

    // Identity fraction is 0.0
    public func burned(frac: Frac) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(1.0 - (1.0 - red) / f, 1.0),
            green: min(1.0 - (1.0 - green) / f, 1.0),
            blue: min(1.0 - (1.0 - blue) / f, 1.0),
            alpha: alpha)
    }

    public static let Black = Color(red: 0, green: 0, blue: 0)
    public static let DarkGray = Color(red: 1 / 3.0, green: 1 / 3.0, blue: 1 / 3.0)
    public static let LightGray = Color(red: 2 / 3.0, green: 2 / 3.0, blue: 2 / 3.0)
    public static let White = Color(red: 1, green: 1, blue: 1)
    public static let Gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    public static let Red = Color(red: 1, green: 0, blue: 0)
    public static let Green = Color(red: 0, green: 1, blue: 0)
    public static let DarkGreen = Color(red: 0, green: 0.5, blue: 0)
    public static let Blue = Color(red: 0, green: 0, blue: 1)
    public static let Cyan = Color(red: 0, green: 1, blue: 1)
    public static let Yellow = Color(red: 1, green: 1, blue: 0)
    public static let Magenta = Color(red: 1, green: 0, blue: 1)
    public static let Orange = Color(red: 1, green: 0.5, blue: 0)
    public static let Purple = Color(red: 0.5, green: 0, blue: 0.5)
    public static let Brown = Color(red: 0.6, green: 0.4, blue: 0.2)
    public static let Clear = Color(red: 0, green: 0, blue: 0, alpha: 0)

    public static let Chartreuse = blend(.Yellow, .Green, frac: 0.5)
    public static let Gold = Color(redByte: 251, greenByte: 212, blueByte: 55)
    public static let BlueGreen = Color(redByte: 0, greenByte: 169, blueByte: 149)
    public static let MediumBlue = Color(redByte: 0, greenByte: 110, blueByte: 185)
    public static let DeepBlue = Color(redByte: 60, greenByte: 55, blueByte: 149)

}

#if os(OSX) || os(iOS) || os(tvOS)
extension Color {
    public var cgColor: CGColor {
        return CGColorCreate(sharedColorSpaceRGB, [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)])!
    }
}
#endif

#if os(iOS) || os(tvOS)
    extension Color {
        public var uiColor: UIColor {
            return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
    }
#endif

extension Color : CustomStringConvertible {
    public var description: String {
        get {
            return "Color(\(red), \(green), \(blue), \(alpha))"
        }
    }
}

public func *(lhs: Color, rhs: Frac) -> Color {
    return lhs.multipliedBy(rhs)
}

public func +(lhs: Color, rhs: Color) -> Color {
    return lhs.addedTo(rhs)
}
