//
//  ScrollView.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/7/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import UIKit

open class ScrollView: UIScrollView, Skinnable {
    @IBInspectable public var isTransparentToTouches: Bool = false

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
        ~self
        setup()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _didMoveToSuperview()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
    }

    open func setup() { }
}
