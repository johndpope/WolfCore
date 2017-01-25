//
//  ScrollView.swift
//  WolfCore
//
//  Created by Robert McNally on 12/7/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import UIKit

open class ScrollView: UIScrollView, Skinnable {
    private var _mySkin: Skin?
    public var mySkin: Skin? {
        get { return _mySkin ?? inheritedSkin }
        set { _mySkin = newValue; updateAppearanceContainer(skin: _mySkin) }
    }

    /// Can be set from Interface Builder
    public var transparentToTouches: Bool = false

    /// Can be set from Interface Builder
    public var transparentBackground = false {
        didSet {
            if transparentBackground {
                makeTransparent()
            }
        }
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
        ~self
        setup()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearanceContainer(skin: mySkin)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
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
