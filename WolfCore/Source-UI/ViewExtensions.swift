//
//  ViewExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSView = UIView
    public typealias OSEdgeInsets = UIEdgeInsets
    public let OSEdgeInsetsZero = UIEdgeInsetsZero
#elseif os(OSX)
    import Cocoa
    public typealias OSView = NSView
    public typealias OSEdgeInsets = NSEdgeInsets
    public let OSEdgeInsetsZero = NSEdgeInsetsZero
#endif

public typealias ViewBlock = (OSView) -> Bool

extension OSView {
#if os(iOS) || os(tvOS)
    public func makeTransparent(debugColor debugColor: OSColor = OSColor.Clear, debug: Bool = false) {
        opaque = false
        backgroundColor = debug ? debugColor.colorWithAlphaComponent(0.25) : OSColor.Clear
    }
#endif

#if os(iOS) || os(tvOS)
    public func tranparentPointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
    }
#endif
}

extension OSView {
    public func constrainToSuperview(active active: Bool = true, insets: OSEdgeInsets = OSEdgeInsetsZero, identifier: String? = nil) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        return constrain(toView: superview!, active: active, insets: insets, identifier: identifier)
    }

    public func constrain(toView view: OSView, active: Bool = true, insets: OSEdgeInsets = OSEdgeInsetsZero, identifier: String? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            leadingAnchor == view.leadingAnchor + insets.left =%= [identifier, "Leading"],
            trailingAnchor == view.trailingAnchor - insets.right =%= [identifier, "Trailing"],
            topAnchor == view.topAnchor + insets.top =%= [identifier, "Top"],
            bottomAnchor == view.bottomAnchor - insets.bottom =%= [identifier, "Bottom"]
        ]
        if active {
            activateConstraints(constraints)
        }
        return constraints
    }

    public func constrainCenterToCenterOfSuperview(active active: Bool = true, identifier: String? = nil) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        return constrainCenter(toCenterOfView: superview!, active: active, identifier: identifier)
    }

    public func constrainCenter(toCenterOfView view: OSView, active: Bool = true, identifier: String? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            centerXAnchor == view.centerXAnchor =%= [identifier, "CenterY"],
            centerYAnchor == view.centerYAnchor =%= [identifier, "CenterX"]
        ]
        if active {
            activateConstraints(constraints)
        }
        return constraints
    }

    public func constrain(toSize size: CGSize, active: Bool = true, identifier: String? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            widthAnchor == size.width =%= [identifier, "CenterY"],
            heightAnchor == size.height =%= [identifier, "CenterY"]
        ]
        if active {
            activateConstraints(constraints)
        }
        return constraints
    }
}

extension OSView {
    public func descendentViews<T: OSView>(ofClass aClass: AnyClass) -> [T] {
        var resultViews = [T]()
        self.forViewsInHierachy { view -> Bool in
            if view.dynamicType == aClass {
                resultViews.append(view as! T)
            }
            return false
        }
        return resultViews
    }

    public func forViewsInHierachy(operate: ViewBlock) {
        var stack = [self]
        repeat {
            let view = stack.removeLast()
            let stop = operate(view)
            guard !stop else { return }
            view.subviews.reverse().forEach { subview in
                stack.append(subview)
            }
        } while !stack.isEmpty
    }

    public func allDescendants() -> [OSView] {
        var descendants = [OSView]()
        forViewsInHierachy { currentView -> Bool in
            if currentView !== self {
                descendants.append(currentView)
            }
            return false
        }
        return descendants
    }

    public func allAncestors() -> [OSView] {
        var parents = [OSView]()
        var currentParent: OSView? = superview
        while currentParent != nil {
            parents.append(currentParent!)
            currentParent = currentParent!.superview
        }
        return parents
    }
}

public enum ViewRelationship {
    case unrelated
    case same
    case sibling
    case ancestor
    case descendant
    case cousin(OSView)
}

extension OSView {
    public func relationship(toView view: OSView) -> ViewRelationship {
        guard self !== view else { return .same }

        if let superview = superview {
            for sibling in superview.subviews {
                guard sibling !== self else { continue }
                if sibling === view { return .sibling }
            }
        }

        let ancestors = allAncestors()

        if ancestors.contains(view) {
            return .descendant
        }

        if let commonAncestor = (ancestors as NSArray).firstObjectCommonWithArray(view.allAncestors()) as? OSView {
            return .cousin(commonAncestor)
        }

        if allDescendants().contains(view) {
            return .ancestor
        }

        return .unrelated
    }
}

#if os(OSX)
    extension NSView {
        public var alpha: CGFloat {
            get {
                return alphaValue
            }

            set {
                alphaValue = newValue
            }
        }
    }
#endif
