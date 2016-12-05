//
//  StackView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class StackView: UIStackView, Skinnable {
    public var skinChangedAction: SkinChangedAction!
    public var transparentToTouches = false

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(arrangedSubviews views: [UIView]) {
        self.init(arrangedSubviews: views)
        _setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        _setup()
    }

    private func _setup() {
        ~self
        setup()
        setupSkinnable()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }

    open func setup() { }

    open func updateAppearance() { }
}
