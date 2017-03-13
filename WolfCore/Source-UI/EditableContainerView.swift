//
//  EditableContainerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/13/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class EditableContainerView: View, Editable {
    public var isEditing = false
    public let normalView: UIView
    public let editingView: UIView

    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!

    public init(normalView: UIView, editingView: UIView) {
        self.normalView = normalView
        self.editingView = editingView
        super.init(frame: .zero)

        addSubview(normalView)
        normalView.constrainCenterToCenter()
        normalView.setNeedsLayout()
        normalView.layoutIfNeeded()

        widthConstraint = activateConstraint(widthAnchor == normalView.frame.width)
        heightConstraint = activateConstraint(heightAnchor == normalView.frame.height)

//        addSubview(editingView)
//        editingView.constrainCenterToCenter()
//        editingView.alpha = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func syncToEditing(animated: Bool) {
        switch isEditing {
        case false:
            addSubview(normalView)
            normalView.constrainCenterToCenter()
            normalView.layoutIfNeeded()
            normalView.center = bounds.midXmidY
            widthConstraint.constant = normalView.frame.width
            heightConstraint.constant = normalView.frame.height
            normalView.alpha = 0
        case true:
            addSubview(editingView)
            editingView.constrainCenterToCenter()
            editingView.layoutIfNeeded()
            editingView.center = bounds.midXmidY
            widthConstraint.constant = editingView.frame.width
            heightConstraint.constant = editingView.frame.height
            editingView.alpha = 0
        }
        setNeedsLayout()
        dispatchAnimated(animated, animations: {
            switch self.isEditing {
            case false:
                self.normalView.alpha = 1
                self.editingView.alpha = 0
            case true:
                self.editingView.alpha = 1
                self.normalView.alpha = 0
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            switch self.isEditing {
            case false:
                self.editingView.removeFromSuperview()
            case true:
                self.normalView.removeFromSuperview()
            }
        })
    }
}
