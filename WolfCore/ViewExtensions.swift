//
//  ViewExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIView {
    public func makeTransparent(debugColor debugColor: UIColor = UIColor.clearColor(), debug: Bool = false) {
        opaque = false
        backgroundColor = debug ? debugColor.colorWithAlphaComponent(0.25) : UIColor.clearColor()
    }
    
    public func tranparentPointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
    }
}

extension UIView {
    public func constrainToSuperview(active active: Bool = true) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        let sv = superview!
        let constraints = [
            leadingAnchor == sv.leadingAnchor,
            trailingAnchor == sv.trailingAnchor,
            topAnchor == sv.topAnchor,
            bottomAnchor == sv.bottomAnchor
        ]
        if active {
            NSLayoutConstraint.activateConstraints(constraints)
        }
        return constraints
    }
    
    public func constrainToView(view: UIView, active: Bool = true) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        assert(view.superview != nil, "View must have a superview.")
        assert(superview == view.superview, "Views must have same superview.")
        let constraints = [
            centerXAnchor == view.centerXAnchor,
            centerYAnchor == view.centerYAnchor,
            widthAnchor == view.widthAnchor,
            heightAnchor == view.heightAnchor
        ]
        if active {
            NSLayoutConstraint.activateConstraints(constraints)
        }
        return constraints
    }
    
    public func constrainCenterToSuperviewCenter(active active: Bool = true) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        let sv = superview!
        let constraints = [
            centerXAnchor == sv.centerXAnchor,
            centerYAnchor == sv.centerYAnchor
        ]
        if active {
            NSLayoutConstraint.activateConstraints(constraints)
        }
        return constraints
    }
}