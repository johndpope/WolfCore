//
//  View.swift
//  WolfCore
//
//  Created by Robert McNally on 7/6/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class View: UIView {
    /// Can be set from Interface Builder
    public var transparentToTouches: Bool = false
    
    /// Can be set from Interface Builder
    public var transparentBackground: Bool = false {
        didSet {
            if transparentBackground {
                makeTransparent()
            }
        }
    }
    
    /// Can be set from Interface Builder, or in the subclass's Setup() function.
    public var contentNibName: String? = nil
    
    private var endEditingAction: GestureRecognizerAction!
    
    /// Can be set from Interface Builder
    public var endsEditingWhenTapped: Bool = false {
        didSet {
            if endsEditingWhenTapped {
                endEditingAction = addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] _ in
                    self.window?.endEditing(false)
                }
            } else {
                endEditingAction = nil
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        loadContentFromNib()
    }

    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }
    
    private func _setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    // Override in subclasses
    public func setup() { }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if transparentToTouches {
            return tranparentPointInside(point, withEvent: event)
        } else {
            return super.pointInside(point, withEvent: event)
        }
    }
    
    private func loadContentFromNib() {
        if let contentNibName = contentNibName {
            let view = ~loadViewFromNib(named: contentNibName, owner: self)
            transferContentFromView(view)
        }
    }
    
    private func transferContentFromView(view: UIView) {
        // These are attributes that can be set from Interface Builder
        contentMode = view.contentMode
        tag = view.tag
        userInteractionEnabled = view.userInteractionEnabled
        multipleTouchEnabled = view.multipleTouchEnabled
        alpha = view.alpha
        backgroundColor = view.backgroundColor
        tintColor = view.tintColor
        opaque = view.opaque
        hidden = view.hidden
        clearsContextBeforeDrawing = view.clearsContextBeforeDrawing
        clipsToBounds = view.clipsToBounds
        autoresizesSubviews = view.autoresizesSubviews
        
        // Copy these arrays because the act of moving the subviews will remove constraints
        let constraints = view.constraints
        let subviews = view.subviews
        
        for subview in subviews {
            addSubview(subview)
        }
        
        for constraint in constraints {
            var firstItem = constraint.firstItem
            let firstAttribute = constraint.firstAttribute
            let relation = constraint.relation
            var secondItem = constraint.secondItem
            let secondAttribute = constraint.secondAttribute
            let multiplier = constraint.multiplier
            let constant = constraint.constant
            
            if firstItem === view {
                firstItem = self
            }
            if secondItem === view {
                secondItem = self
            }
            addConstraint(NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant))
        }
    }
}
