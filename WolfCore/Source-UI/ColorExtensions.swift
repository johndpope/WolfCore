//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSColor = UIColor
#else
    import Cocoa
    public typealias OSColor = NSColor
#endif

extension OSColor {
    public convenience init(_ color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }

    public convenience init(string: String) throws {
        self.init(try Color(string: string))
    }

    public static func toColor(osColor: OSColor) -> Color {
        return osColor.cgColor |> CGColor.toColor
    }

    public class func diagonalStripesPattern(color1: OSColor, color2: OSColor, flipped: Bool = false) -> OSColor {
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
        let image = newImage(withSize: bounds.size, opaque: true, scale: mainScreenScale, renderingMode: .alwaysOriginal) { context in
            context.setFillColor(color1.cgColor)
            context.fill(bounds)
            let path = OSBezierPath()
            if flipped {
                path.addClosedPolygon(withPoints: [bounds.maxXmidY, bounds.maxXminY, bounds.midXminY])
                path.addClosedPolygon(withPoints: [bounds.maxXmaxY, bounds.minXminY, bounds.minXmidY, bounds.midXmaxY])
            } else {
                path.addClosedPolygon(withPoints: [bounds.midXminY, bounds.minXminY, bounds.minXmidY])
                path.addClosedPolygon(withPoints: [bounds.maxXminY, bounds.minXmaxY, bounds.midXmaxY, bounds.maxXmidY])
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
}

extension OSColor {
    public var debugSummary: String {
        return (self |> OSColor.toColor).debugSummary
    }
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
        } catch let error {
            logError(error)
        }
    }
}

public struct NamedColor: ExtensibleEnumeratedName, Reference {
    public let name: String
    public let color: OSColor

    public init(_ name: String, _ color: OSColor) {
        self.name = name
        self.color = color
    }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: (name: String, color: OSColor)) { self.init(rawValue.name, rawValue.color) }
    public var rawValue: (name: String, color: OSColor) { return (name: name, color: color) }

    // Reference
    public var referent: OSColor {
        return color
    }
}

public func == (left: NamedColor, right: NamedColor) -> Bool {
    return left.name == right.name
}

public postfix func ® (lhs: NamedColor) -> OSColor {
    return lhs.referent
}

extension OSColor {
    public var luminance: Frac {
        return (self |> Color.init).luminance
    }

    public func multiplied(by rhs: Frac) -> OSColor {
        return Color(self).multiplied(by: rhs) |> OSColor.init
    }

    public func added(to rhs: OSColor) -> OSColor {
        return Color(self).added(to: Color(rhs)) |> OSColor.init
    }

    public func lightened(by frac: Frac) -> OSColor {
        return Color(self).lightened(by: frac) |> OSColor.init
    }

    public func darkened(by frac: Frac) -> OSColor {
        return Color(self).darkened(by: frac) |> OSColor.init
    }

    public func dodged(by frac: Frac) -> OSColor {
        return Color(self).dodged(by: frac) |> OSColor.init
    }

    public func burned(by frac: Frac) -> OSColor {
        return Color(self).burned(by: frac) |> OSColor.init
    }

}

extension OSColor {
    public static func oneColor(_ color: OSColor) -> ColorFunc {
        return WolfCore.oneColor(Color(color))
    }

    public static func twoColor(_ color1: OSColor, _ color2: OSColor) -> ColorFunc {
        return WolfCore.twoColor(Color(color1), Color(color2))
    }

    public static func threeColor(_ color1: OSColor, _ color2: OSColor, _ color3: OSColor) -> ColorFunc {
        return WolfCore.threeColor(Color(color1), Color(color2), Color(color3))
    }
}
