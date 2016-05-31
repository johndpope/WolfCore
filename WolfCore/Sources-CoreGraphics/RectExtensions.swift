//
//  RectExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

extension CGRect {
    // Corners
    public var minXminY: CGPoint { return CGPoint(x: minX, y: minY) }
    public var maxXminY: CGPoint { return CGPoint(x: maxX, y: minY) }
    public var maxXmaxY: CGPoint { return CGPoint(x: maxX, y: maxY) }
    public var minXmaxY: CGPoint { return CGPoint(x: minX, y: maxY) }

    // Sides
    public var midXminY: CGPoint { return CGPoint(x: midX, y: minY) }
    public var midXmaxY: CGPoint { return CGPoint(x: midX, y: maxY) }
    public var maxXmidY: CGPoint { return CGPoint(x: maxX, y: midY) }
    public var minXmidY: CGPoint { return CGPoint(x: minX, y: midY) }

    // Already provided by CGRect:
    //  public var minX
    //  public var midX
    //  public var maxX
    //  public var minY
    //  public var midY
    //  public var maxY

    // Center
    public var midXmidY: CGPoint { return CGPoint(x: midX, y: midY) }

    // Dimensions

    // Already provided by CGRect:
    //  public var width
    //  public var height
}

extension CGRect {
    // Corners
    public func settingMinXminY(p: CGPoint) -> CGRect { return CGRect(origin: p, size: size) }
    public func settingMaxXminY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x - size.width, y: p.y), size: size) }
    public func settingMaxXmaxY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x - size.width, y: p.y - size.height), size: size) }
    public func settingMinXmaxY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x, y: p.y - size.height), size: size) }

    // Sides
    public func settingMinX(x: CGFloat) -> CGRect { return CGRect(origin: CGPoint(x: x, y: origin.y), size: size) }
    public func settingMaxX(x: CGFloat) -> CGRect { return CGRect(origin: CGPoint(x: x - size.width, y: origin.y), size: size) }
    public func settingMidX(x: CGFloat) -> CGRect { return CGRect(origin: CGPoint(x: x - size.width / 2, y: origin.y), size: size) }

    public func settingMinY(y: CGFloat) -> CGRect { return CGRect(origin: CGPoint(x: origin.x, y: y), size: size) }
    public func settingMaxY(y: CGFloat) -> CGRect { return CGRect(origin: CGPoint(x: origin.x, y: y - size.height), size: size) }
    public func settingMidY(y: CGFloat) -> CGRect { return CGRect(origin: CGPoint(x: origin.x, y: y - size.height / 2), size: size) }

    public func settingMidXminY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x - size.width / 2, y: p.y), size: size) }
    public func settingMidXmaxY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x - size.width / 2, y: p.y - size.height), size: size) }
    public func settingMaxXmidY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x - size.width, y: p.y - size.height / 2), size: size) }
    public func settingMinXmidY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x, y: p.y - size.height / 2), size: size) }

    // Center
    public func settingMidXmidY(p: CGPoint) -> CGRect { return CGRect(origin: CGPoint(x: p.x - size.width / 2, y: p.y - size.height / 2), size: size) }

    // Dimensions
    public func settingWidth(w: CGFloat) -> CGRect { return CGRect(origin: origin, size: CGSize(width: w, height: size.height)) }
    public func settingHeight(h: CGFloat) -> CGRect { return CGRect(origin: origin, size: CGSize(width: size.width, height: h)) }
}

extension CGRect {
    // These functions can produce rectangles that have a different size.

    // Corners
    public func settingMinXminYIndependent(p: CGPoint) -> CGRect { return settingMinXIndependent(p.x).settingMinYIndependent(p.y) }
    public func settingMaxXminYIndependent(p: CGPoint) -> CGRect { return settingMaxXIndependent(p.x).settingMinYIndependent(p.y) }
    public func settingMaxXmaxYIndependent(p: CGPoint) -> CGRect { return settingMaxXIndependent(p.x).settingMaxYIndependent(p.y) }
    public func settingMinXmaxYIndependent(p: CGPoint) -> CGRect { return settingMinXIndependent(p.x).settingMaxYIndependent(p.y) }

    // Sides
    public func settingMinXIndependent(x: CGFloat) -> CGRect { let dx = minX - x; return settingMinX(x).settingWidth(width + dx).standardized }
    public func settingMaxXIndependent(x: CGFloat) -> CGRect { let dx = maxX - x; return settingMaxX(x).settingWidth(width + dx).standardized }

    public func settingMinYIndependent(y: CGFloat) -> CGRect { let dy = minY - y; return settingMinY(y).settingHeight(height + dy).standardized }
    public func settingMaxYIndependent(y: CGFloat) -> CGRect { let dy = maxY - y; return settingMaxY(y).settingHeight(height + dy).standardized }
}

extension CGRect {
    // Corners
    public mutating func setMinXminY(p: CGPoint) { origin = p }
    public mutating func setMaxXminY(p: CGPoint) { origin.x = p.x - size.width; origin.y = p.y }
    public mutating func setMaxXmaxY(p: CGPoint) { origin.x = p.x - size.width; origin.y = p.y - size.height }
    public mutating func setMinXmaxY(p: CGPoint) { origin.x = p.x; origin.y = p.y - size.height }

    // Sides
    public mutating func setMinX(x: CGFloat) { origin.x = x }
    public mutating func setMaxX(x: CGFloat) { origin.x = x - size.width }
    public mutating func setMidX(x: CGFloat) { origin.x = x - size.width / 2 }

    public mutating func setMinY(y: CGFloat) { origin.y = y }
    public mutating func setMaxY(y: CGFloat) { origin.y = y - size.height }
    public mutating func setMidY(y: CGFloat) { origin.y = y - size.height / 2 }

    public mutating func setMidXminY(p: CGPoint) { origin.x = p.x - size.width / 2; origin.y = p.y }
    public mutating func setMidXmaxY(p: CGPoint) { origin.x = p.x - size.width / 2; origin.y = p.y - size.height }
    public mutating func setMaxXmidY(p: CGPoint) { origin.x = p.x - size.width; origin.y = p.y - size.height / 2 }
    public mutating func setMinXmidY(p: CGPoint) { origin.x = p.x; origin.y = p.y - size.height / 2 }

    // Dimensions
    public mutating func setWidth(w: CGFloat) { size.width = w }
    public mutating func setHeight(h: CGFloat) { size.height = h }
}

extension CGRect {
    // These functions can produce rectangles that have a different size.

    // Corners
    public mutating func setMinXminYIndependent(p: CGPoint) { setMinXIndependent(p.x); setMinYIndependent(p.y) }
    public mutating func setMaxXminYIndependent(p: CGPoint) { setMaxXIndependent(p.x); setMinYIndependent(p.y) }
    public mutating func setMaxXmaxYIndependent(p: CGPoint) { setMaxXIndependent(p.x); setMaxYIndependent(p.y) }
    public mutating func setMinXmaxYIndependent(p: CGPoint) { setMinXIndependent(p.x); setMaxYIndependent(p.y) }

    // Sides
    public mutating func setMinXIndependent(x: CGFloat) { let dx = minX - x; setMinX(x); size.width += dx; standardizeInPlace() }
    public mutating func setMaxXIndependent(x: CGFloat) { let dx = maxX - x; setMaxX(x); size.width += dx; standardizeInPlace() }

    public mutating func setMinYIndependent(y: CGFloat) { let dy = minY - y; setMinY(y); size.height += dy; standardizeInPlace() }
    public mutating func setMaxYIndependent(y: CGFloat) { let dy = maxY - y; setMaxY(y); size.height += dy; standardizeInPlace() }
}

extension CGRect {
    public var debugName: String {
        let joiner = Joiner("(", ")", " ")
        joiner.append(minX %% 3, minY %% 3, width %% 3, height %% 3)
        return joiner.description
    }
}
