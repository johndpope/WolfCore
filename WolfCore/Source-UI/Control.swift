//
//  Control.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/22/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class Control: UIControl, Skinnable {
    public var mySkin: Skin? {
        didSet {
            updateAppearance()
        }
    }

    public var skinChangedAction: SkinChangedAction!

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
        ~~self
        setup()
        setupSkinnable()
    }

    open func updateAppearance() {
        (self as Skinnable).updateAppearance()
    }

    open func setup() { }
}
