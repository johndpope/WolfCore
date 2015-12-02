//
//  PlaceholderView.swift
//  WolfCore
//
//  Created by Robert McNally on 7/24/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

@IBDesignable public class PlaceholderView: View {
    
    // This view is visually transparent
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            makeTransparent(debugColor: UIColor.greenColor(), debug: true)
        }
    }
    
    public override func setup() {
        super.setup()
        transparentToTouches = true
    }
    
    public func transferSubviewsToView(view: UIView) {
        let constraints = self.constraints
        
        let subviews = self.subviews
        for subview in subviews {
            view.addSubview(subview)
        }
        
        for constraint in constraints {
            var firstItem = constraint.firstItem
            let firstAttribute = constraint.firstAttribute
            let relation = constraint.relation
            var secondItem = constraint.secondItem
            let secondAttribute = constraint.secondAttribute
            let multiplier = constraint.multiplier
            let constant = constraint.constant
            
            if firstItem === self {
                firstItem = view
            }
            if secondItem === self {
                secondItem = view
            }
            view.addConstraint(NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant))
        }
    }
}
