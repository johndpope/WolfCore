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
    public let OSEdgeInsetsZero = UIEdgeInsets.zero
    public let OSViewNoIntrinsicMetric = UIViewNoIntrinsicMetric
#elseif os(macOS)
    import Cocoa
    public typealias OSView = NSView
    public typealias OSEdgeInsets = EdgeInsets
    public let OSEdgeInsetsZero = NSEdgeInsetsZero
    public let OSViewNoIntrinsicMetric = NSViewNoIntrinsicMetric
#endif

public typealias ViewBlock = (OSView) -> Bool

extension OSView {
#if !os(macOS)
    public func makeTransparent(debugColor: OSColor = .clear, debug: Bool = false) {
        isOpaque = false
        backgroundColor = debug ? debugColor.withAlphaComponent(0.25) : .clear
    }
#endif

#if !os(macOS)
    public func isTransparentToTouch(at point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
#endif
}

extension OSView {
    @discardableResult public func constrainToSuperview(active: Bool = true, insets: OSEdgeInsets = OSEdgeInsetsZero, identifier: String? = nil) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        return constrain(toView: superview!, active: active, insets: insets, identifier: identifier)
    }

    @discardableResult public func constrain(toView view: OSView, active: Bool = true, insets: OSEdgeInsets = OSEdgeInsetsZero, identifier: String? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            leadingAnchor == view.leadingAnchor + insets.left =%= [identifier, "leading"],
            trailingAnchor == view.trailingAnchor - insets.right =%= [identifier, "trailing"],
            topAnchor == view.topAnchor + insets.top =%= [identifier, "top"],
            bottomAnchor == view.bottomAnchor - insets.bottom =%= [identifier, "bottom"]
        ]
        if active {
            activateConstraints(constraints)
        }
        return constraints
    }

    @discardableResult public func constrainCenterToCenterOfSuperview(active: Bool = true, identifier: String? = nil) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        return constrainCenter(toCenterOfView: superview!, active: active, identifier: identifier)
    }

    public func constrainCenter(toCenterOfView view: OSView, active: Bool = true, identifier: String? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            centerXAnchor == view.centerXAnchor =%= [identifier, "centerY"],
            centerYAnchor == view.centerYAnchor =%= [identifier, "centerX"]
        ]
        if active {
            activateConstraints(constraints)
        }
        return constraints
    }

    @discardableResult public func constrain(toSize size: CGSize, active: Bool = true, identifier: String? = nil) -> [NSLayoutConstraint] {
        let constraints = [
            widthAnchor == size.width =%= [identifier, "centerY"],
            heightAnchor == size.height =%= [identifier, "centerY"]
        ]
        if active {
            activateConstraints(constraints)
        }
        return constraints
    }
}

#if os(iOS) || os(tvOS)
extension UIView {
    public func setBorder(cornerRadius radius: CGFloat? = nil, width: CGFloat? = nil, color: UIColor? = nil) {
        if let radius = radius { layer.cornerRadius = radius }
        if let width = width { layer.borderWidth = width }
        if let color = color { layer.borderColor = color.cgColor }
    }
}
#endif

extension OSView {
    public func descendantViews<T>() -> [T] {
        var resultViews = [T]()
        self.forViewsInHierarchy { view -> Bool in
            if let view = view as? T {
                resultViews.append(view)
            }
            return false
        }
        return resultViews
    }

    public func forViewsInHierarchy(operate: ViewBlock) {
        var stack = [self]
        repeat {
            let view = stack.removeLast()
            let stop = operate(view)
            guard !stop else { return }
            view.subviews.forEach { subview in
                stack.append(subview)
            }
        } while !stack.isEmpty
    }

    public func allDescendants() -> [OSView] {
        var descendants = [OSView]()
        forViewsInHierarchy { currentView -> Bool in
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

        if let commonAncestor = (ancestors as NSArray).firstObjectCommon(with: view.allAncestors()) as? OSView {
            return .cousin(commonAncestor)
        }

        if allDescendants().contains(view) {
            return .ancestor
        }

        return .unrelated
    }
}

#if os(macOS)
    extension NSView {
        public var alpha: CGFloat {
            get {
                return alphaValue
            }

            set {
                alphaValue = newValue
            }
        }

        public func setNeedsLayout() {
            needsLayout = true
        }

        public func layoutIfNeeded() {
            layoutSubtreeIfNeeded()
        }
    }
#endif

#if os(iOS)
    extension UIView {
        public var statusBarFrame: CGRect? {
            guard let window = window else { return nil }
            let statusBarFrame = UIApplication.shared.statusBarFrame
            let statusBarWindowRect = window.convert(statusBarFrame, from: nil)
            let statusBarViewRect = convert(statusBarWindowRect, from: nil)
            return statusBarViewRect
        }
    }

    extension UIView {
        public func snapshot(afterScreenUpdates: Bool = false) -> UIImage {
            return newImage(withSize: bounds.size) { _ in
                self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
            }
        }
    }
#endif

extension UIResponder {
    public var viewController: UIViewController? {
        var resultViewController: UIViewController?
        var responder: UIResponder! = self
        repeat {
            if let viewController = responder as? UIViewController {
                resultViewController = viewController
                break
            }
            responder = responder.next
        } while responder != nil
        return resultViewController
    }
}
