//
//  StackView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class StackView: UIStackView {
    public var transparentToTouches = false

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(arrangedSubviews views: [UIView]) {
        super.init(arrangedSubviews: views)
        _setup()
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
        ~self
        setup()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    /// Override in subclasses
    public func setup() { }

    /// Override in subclasses
    public func updateAppearance() { }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}
