//
//  AutolayoutUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
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

public func activateConstraints(constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    NSLayoutConstraint.activateConstraints(constraints)
    return constraints
}

public func activateConstraints(constraints: NSLayoutConstraint...) -> [NSLayoutConstraint] {
    NSLayoutConstraint.activateConstraints(constraints)
    return constraints
}

public func deactivateConstraints(constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.deactivateConstraints(constraints)
}

public func deactivateConstraints(constraints: NSLayoutConstraint...) {
    NSLayoutConstraint.deactivateConstraints(constraints)
}

#if os(iOS) || os(tvOS)
    public prefix func ~<T: UIView> (right: T) -> T {
        right.translatesAutoresizingMaskIntoConstraints = false
        return right
    }

    prefix operator ~~ { }

    public prefix func ~~<T: UIView> (right: T) -> T {
        right.translatesAutoresizingMaskIntoConstraints = false
        right.makeTransparent()
        return right
    }
#endif

public func string(forRelation relation: NSLayoutRelation) -> String {
    let result: String
    switch relation {
    case .Equal:
        result = "=="
    case .LessThanOrEqual:
        result = "<="
    case .GreaterThanOrEqual:
        result = ">="
    }
    return result
}

// swiftlint:disable cyclomatic_complexity

#if os(iOS) || os(tvOS)
public func string(forAttribute attribute: NSLayoutAttribute) -> String {
    let result: String
    switch attribute {
    case .Left:
        result = "left"
    case .Right:
        result = "right"
    case .Top:
        result = "top"
    case .Bottom:
        result = "bottom"
    case .Leading:
        result = "leading"
    case .Trailing:
        result = "trailing"
    case .Width:
        result = "width"
    case .Height:
        result = "height"
    case .CenterX:
        result = "centerX"
    case .CenterY:
        result = "centerY"
    case .Baseline:
        result = "baseline"
    case .FirstBaseline:
        result = "firstBaseline"
    case .NotAnAttribute:
        result = "notAnAttribute"
    case .LeftMargin:
        result = "leftMargin"
    case .RightMargin:
        result = "rightMargin"
    case .TopMargin:
        result = "topMargin"
    case .BottomMargin:
        result = "bottomMargin"
    case .LeadingMargin:
        result = "leadingMargin"
    case .TrailingMargin:
        result = "trailingMargin"
    case .CenterXWithinMargins:
        result = "centerXWithinMargins"
    case .CenterYWithinMargins:
        result = "centerYWithinMargins"
    }
    return result
}
#elseif os(OSX)
    public func string(forAttribute attribute: NSLayoutAttribute) -> String {
        let result: String
        switch attribute {
        case .Left:
            result = "left"
        case .Right:
            result = "right"
        case .Top:
            result = "top"
        case .Bottom:
            result = "bottom"
        case .Leading:
            result = "leading"
        case .Trailing:
            result = "trailing"
        case .Width:
            result = "width"
        case .Height:
            result = "height"
        case .CenterX:
            result = "centerX"
        case .CenterY:
            result = "centerY"
        case .Baseline:
            result = "baseline"
        case .FirstBaseline:
            result = "firstBaseline"
        case .NotAnAttribute:
            result = "notAnAttribute"
        }
        return result
    }
#endif

// swiftlint:enable cyclomatic_complexity
