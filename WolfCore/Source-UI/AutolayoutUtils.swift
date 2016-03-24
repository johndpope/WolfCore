//
//  AutolayoutUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias OSLayoutPriority = UILayoutPriority
#else
    import Cocoa
    public typealias OSLayoutPriority = NSLayoutPriority
#endif

public func + (left: NSLayoutAnchor!, right: CGFloat) -> (anchor: NSLayoutAnchor, constant: CGFloat) {
    return (left, right)
}

public func - (left: NSLayoutAnchor!, right: CGFloat) -> (anchor: NSLayoutAnchor, constant: CGFloat) {
    return (left, -right)
}


public func * (left: NSLayoutDimension!, right: CGFloat) -> (anchor: NSLayoutDimension, multiplier: CGFloat) {
    return (left, right)
}

public func + (left: (anchor: NSLayoutDimension, multiplier: CGFloat), right: CGFloat) -> (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) {
    return (anchor: left.anchor, multiplier: left.multiplier, constant: right)
}


// ⦿
// CIRCLED BULLET
// Unicode: U+29BF, UTF-8: E2 A6 BF
//

// "priority assign"
infix operator =&= { associativity left precedence 95 }


public func == (left: NSLayoutAnchor, right: NSLayoutAnchor) -> NSLayoutConstraint {
    return left.constraintEqualToAnchor(right)
}

public func == (left: NSLayoutAnchor, right: (anchor: NSLayoutAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraintEqualToAnchor(right.anchor, constant: right.constant)
}

public func == (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraintEqualToConstant(right)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraintEqualToAnchor(right.anchor, multiplier: right.multiplier)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraintEqualToAnchor(right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func >= (left: NSLayoutAnchor, right: NSLayoutAnchor) -> NSLayoutConstraint {
    return left.constraintGreaterThanOrEqualToAnchor(right)
}

public func >= (left: NSLayoutAnchor, right: (anchor: NSLayoutAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraintGreaterThanOrEqualToAnchor(right.anchor, constant: right.constant)
}

public func >= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraintGreaterThanOrEqualToConstant(right)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraintGreaterThanOrEqualToAnchor(right.anchor, multiplier: right.multiplier)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraintGreaterThanOrEqualToAnchor(right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func <= (left: NSLayoutAnchor, right: NSLayoutAnchor) -> NSLayoutConstraint {
    return left.constraintLessThanOrEqualToAnchor(right)
}

public func <= (left: NSLayoutAnchor, right: (anchor: NSLayoutAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraintLessThanOrEqualToAnchor(right.anchor, constant: right.constant)
}

public func <= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraintLessThanOrEqualToConstant(right)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraintLessThanOrEqualToAnchor(right.anchor, multiplier: right.multiplier)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraintLessThanOrEqualToAnchor(right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func =&= (left: NSLayoutConstraint, right: OSLayoutPriority) -> NSLayoutConstraint {
    left.priority = right
    return left
}

#if os(iOS)
    public prefix func ~<T: OSView> (right: T) -> T {
        right.translatesAutoresizingMaskIntoConstraints = false
        return right
    }

    prefix operator ~~ { }

    public prefix func ~~<T: OSView> (right: T) -> T {
        right.translatesAutoresizingMaskIntoConstraints = false
        right.makeTransparent()
        return right
    }
#endif
