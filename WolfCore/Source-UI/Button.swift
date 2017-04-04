//
//  Button.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

open class Button: UIButton, Skinnable {
    open override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(title(for: .normal)?.localized(onlyIfTagged: true), for: .normal)
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
        __setup()
        setup()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _didMoveToSuperview()
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
        guard let skin = skin else { return }
        tintColor = skin.buttonTintColor
        setTitleColor(skin.buttonTintColor, for: .normal)
        setTitleColor(skin.buttonHighlightedTintColor, for: .highlighted)
        setTitleColor(skin.buttonDisabledColor, for: .disabled)

        guard let titleLabel = titleLabel, let fontStyle = skin.fontStyles[.buttonTitle] else { return }
        titleLabel.font = fontStyle.font
    }

    open func setup() { }
}
