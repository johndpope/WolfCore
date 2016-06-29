//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
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
    public convenience init(color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }

    public convenience init(string: String) throws {
        self.init(color: try Color(string: string))
    }

    public static func toColor(osColor: OSColor) -> Color {
        return osColor.cgColor |> CGColor.toColor
    }

    public class func diagonalStripesPattern(color1: OSColor, color2: OSColor, flipped: Bool = false) -> OSColor {
        #if os(iOS) || os(tvOS)
            let screenScale = UIScreen.main().scale
        #elseif os(OSX)
            let screenScale: CGFloat = 1.0
        #endif
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
        let image = newImage(withSize: bounds.size, opaque: true, scale: screenScale, renderingMode: .alwaysOriginal) { context in
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

    public static var black: OSColor { return .black() }
    public static var darkGray: OSColor { return .darkGray() }
    public static var lightGray: OSColor { return .lightGray() }
    public static var white: OSColor { return .white() }
    public static var gray: OSColor { return .gray() }
    public static var red: OSColor { return .red() }
    public static var green: OSColor { return .green() }
    public static var blue: OSColor { return .blue() }
    public static var cyan: OSColor { return .cyan() }
    public static var yellow: OSColor { return .yellow() }
    public static var magenta: OSColor { return .magenta() }
    public static var orange: OSColor { return .orange() }
    public static var purple: OSColor { return .purple() }
    public static var brown: OSColor { return .brown() }
    public static var clear: OSColor { return .clear() }
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

public struct ColorReference: ExtensibleEnumeratedName, Reference {
    public let name: String
    public let color: UIColor

    public init(_ name: String, color: UIColor) {
        self.name = name
        self.color = color
    }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: (name: String, color: UIColor)) { self.init(rawValue.name, color: rawValue.color) }
    public var rawValue: (name: String, color: UIColor) { return (name: name, color: color) }

    // Reference
    public var referent: UIColor {
        return color
    }
}

public func == (left: ColorReference, right: ColorReference) -> Bool {
    return left.name == right.name
}

public postfix func ® (lhs: ColorReference) -> UIColor {
    return lhs.referent
}
