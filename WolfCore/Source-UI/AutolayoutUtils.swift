//
//  AutolayoutUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSLayoutPriority = UILayoutPriority
    public let OSLayoutPriorityRequired = UILayoutPriorityRequired
    public let OSLayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh
    public let OSLayoutPriorityDefaultLow = UILayoutPriorityDefaultLow
#else
    import Cocoa
    public typealias OSLayoutPriority = NSLayoutPriority
    public let OSLayoutPriorityRequired = NSLayoutPriorityRequired
    public let OSLayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh
    public let OSLayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow
#endif

public func + (left: NSLayoutXAxisAnchor!, right: CGFloat) -> (anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
    return (left, right)
}

public func + (left: NSLayoutYAxisAnchor!, right: CGFloat) -> (anchor: NSLayoutYAxisAnchor, constant: CGFloat) {
    return (left, right)
}

public func + (left: NSLayoutDimension!, right: CGFloat) -> (anchor: NSLayoutDimension, constant: CGFloat) {
    return (left, right)
}


public func - (left: NSLayoutXAxisAnchor!, right: CGFloat) -> (anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
    return (left, -right)
}

public func - (left: NSLayoutYAxisAnchor!, right: CGFloat) -> (anchor: NSLayoutYAxisAnchor, constant: CGFloat) {
    return (left, -right)
}

public func - (left: NSLayoutDimension!, right: CGFloat) -> (anchor: NSLayoutDimension, constant: CGFloat) {
    return (left, -right)
}


public func * (left: NSLayoutDimension!, right: CGFloat) -> (anchor: NSLayoutDimension, multiplier: CGFloat) {
    return (left, right)
}

public func + (left: (anchor: NSLayoutDimension, multiplier: CGFloat), right: CGFloat) -> (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) {
    return (anchor: left.anchor, multiplier: left.multiplier, constant: right)
}


public func == (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(equalTo: right)
}

public func == (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(equalTo: right)
}

public func == (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
    return left.constraint(equalTo: right)
}


public func == (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, constant: right.constant)
}

public func == (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, constant: right.constant)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, constant: right.constant)
}


public func == (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraint(equalToConstant: right)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, multiplier: right.multiplier)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func >= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right)
}

public func >= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right)
}

public func >= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right)
}


public func >= (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant)
}

public func >= (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant)
}


public func >= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualToConstant: right)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, multiplier: right.multiplier)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func <= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right)
}

public func <= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right)
}

public func <= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right)
}


public func <= (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant)
}

public func <= (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant)
}


public func <= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualToConstant: right)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, multiplier: right.multiplier)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
}

precedencegroup AttributeAssignmentPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}

// "priority assign"
infix operator =&= : AttributeAssignmentPrecedence
//{ associativity left precedence 95 }

public func =&= (left: NSLayoutConstraint, right: OSLayoutPriority) -> NSLayoutConstraint {
    left.priority = right
    return left
}


// "identifier assign"
infix operator =%=  : AttributeAssignmentPrecedence
//{ associativity left precedence 95 }

public func =%= (left: NSLayoutConstraint, right: String) -> NSLayoutConstraint {
    left.identifier = right
    return left
}

public func =%= (left: NSLayoutConstraint, right: [Any?]) -> NSLayoutConstraint {
    let filtered = right.reduce ([String]()) { (accum, elem) in
        var accum = accum
        if let elem = elem {
            accum.append("\(elem)")
        }
        return accum
    }
    return left =%= filtered.joined(separator: "-")
}

public func warnForNoIdentifier(inConstraints constraints: [NSLayoutConstraint]) {
    guard let logger = logger else { return }
    guard logger.groups.contains(.layout) else { return }
    for constraint in constraints {
        if constraint.identifier == nil {
            logWarning("No identifier for: \(constraint)", group: .layout)
        }
    }
}

@discardableResult public func activateConstraints(_ constraints: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    warnForNoIdentifier(inConstraints: constraints)
    NSLayoutConstraint.activate(constraints)
    return constraints
}

@discardableResult public func activateConstraints(_ constraints: NSLayoutConstraint...) -> [NSLayoutConstraint] {
    warnForNoIdentifier(inConstraints: constraints)
    NSLayoutConstraint.activate(constraints)
    return constraints
}

public func deactivateConstraints(_ constraints: [NSLayoutConstraint]?) {
    if let constraints = constraints {
        NSLayoutConstraint.deactivate(constraints)
    }
}

public func deactivateConstraints(_ constraints: NSLayoutConstraint...) {
    NSLayoutConstraint.deactivate(constraints)
}

@discardableResult public func activateConstraint(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint {
    warnForNoIdentifier(inConstraints: [constraint])
    constraint.isActive = true
    return constraint
}

public func replaceConstraint(_ constraint: inout NSLayoutConstraint?, with newConstraint: NSLayoutConstraint?) {
    constraint?.isActive = false
    if let newConstraint = newConstraint {
        constraint = activateConstraint(newConstraint)
    } else {
        constraint = nil
    }
}

public func deactivateConstraint(_ constraint: NSLayoutConstraint) {
    constraint.isActive = false
}

//#if os(iOS) || os(tvOS)
    @discardableResult public prefix func ~<T: OSView> (right: T) -> T {
        right.translatesAutoresizingMaskIntoConstraints = false
        return right
    }
//#endif

public func string(forRelation relation: NSLayoutRelation) -> String {
    let result: String
    switch relation {
    case .equal:
        result = "=="
    case .lessThanOrEqual:
        result = "<="
    case .greaterThanOrEqual:
        result = ">="
    }
    return result
}

// swiftlint:disable cyclomatic_complexity

#if os(iOS) || os(tvOS)
public func string(forAttribute attribute: NSLayoutAttribute) -> String {
    let result: String
    switch attribute {
    case .left:
        result = "left"
    case .right:
        result = "right"
    case .top:
        result = "top"
    case .bottom:
        result = "bottom"
    case .leading:
        result = "leading"
    case .trailing:
        result = "trailing"
    case .width:
        result = "width"
    case .height:
        result = "height"
    case .centerX:
        result = "centerX"
    case .centerY:
        result = "centerY"
    case .firstBaseline:
        result = "firstBaseline"
    case .lastBaseline:
        result = "lastBaseline"
    case .notAnAttribute:
        result = "notAnAttribute"
    case .leftMargin:
        result = "leftMargin"
    case .rightMargin:
        result = "rightMargin"
    case .topMargin:
        result = "topMargin"
    case .bottomMargin:
        result = "bottomMargin"
    case .leadingMargin:
        result = "leadingMargin"
    case .trailingMargin:
        result = "trailingMargin"
    case .centerXWithinMargins:
        result = "centerXWithinMargins"
    case .centerYWithinMargins:
        result = "centerYWithinMargins"
    }
    return result
}
#elseif os(macOS)
    public func string(forAttribute attribute: NSLayoutAttribute) -> String {
        let result: String
        switch attribute {
        case .left:
            result = "left"
        case .right:
            result = "right"
        case .top:
            result = "top"
        case .bottom:
            result = "bottom"
        case .leading:
            result = "leading"
        case .trailing:
            result = "trailing"
        case .width:
            result = "width"
        case .height:
            result = "height"
        case .centerX:
            result = "centerX"
        case .centerY:
            result = "centerY"
        case .lastBaseline:
            result = "lastBaseline"
        case .firstBaseline:
            result = "firstBaseline"
        case .notAnAttribute:
            result = "notAnAttribute"
        }
        return result
    }
#endif

// swiftlint:enable cyclomatic_complexity

#if !os(macOS)
extension UILayoutConstraintAxis: CustomStringConvertible {
    public var description: String {
        switch self {
        case .horizontal:
            return ".horizontal"
        case .vertical:
            return ".vertical"
        }
    }
}
#endif
