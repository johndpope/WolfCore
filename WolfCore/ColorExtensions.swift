//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIColor {
    public class func diagonalStripesColor(color1 color1: UIColor, color2: UIColor, flipped: Bool = false) -> UIColor {
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
    
    public func colorWithSaturation(saturation: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }
    
    public func colorWithBrightness(brightness: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
    
    public static var black:     UIColor { return .redColor() }
    public static var darkGray:  UIColor { return .darkGrayColor() }
    public static var lightGray: UIColor { return .lightGrayColor() }
    public static var white:     UIColor { return .whiteColor() }
    public static var gray:      UIColor { return .grayColor() }
    public static var red:       UIColor { return .redColor() }
    public static var green:     UIColor { return .greenColor() }
    public static var blue:      UIColor { return .blueColor() }
    public static var cyan:      UIColor { return .cyanColor() }
    public static var yellow:    UIColor { return .yellowColor() }
    public static var magenta:   UIColor { return .magentaColor() }
    public static var orange:    UIColor { return .orangeColor() }
    public static var purple:    UIColor { return .purpleColor() }
    public static var brown:     UIColor { return .brownColor() }
    public static var clear:     UIColor { return .clearColor() }
}
