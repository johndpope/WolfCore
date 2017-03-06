//
//  TextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class TextField: UITextField, Skinnable {
    var tintedClearImage: UIImage?
    var lastTintColor: UIColor?
    public static var placeholderColor: UIColor?
    var placeholderColor: UIColor?

    public var followsTintColor = false {
        didSet {
            syncToTintColor()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    private func _setup() {
        __setup()
        setup()
   }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _didMoveToSuperview()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
    }

    open func setup() {
    }

//    open func updateAppearance() {
//        syncToTintColor()
//    }
}

extension TextField {
    fileprivate func syncToTintColor() {
        guard followsTintColor else { return }
        textColor = tintColor
        tintClearImage()
    }

    fileprivate func tintClearImage() {
        let newTintColor: UIColor
        if followsTintColor {
            newTintColor = tintColor
        } else {
            newTintColor = textColor ?? .black
        }
        guard lastTintColor != newTintColor else { return }
        let buttons: [UIButton] = self.descendantViews()
        guard !buttons.isEmpty else { return }
        let button = buttons[0]
        guard let image = button.image(for: .highlighted) else { return }
        tintedClearImage = image.tinted(withColor: newTintColor)
        button.setImage(tintedClearImage, for: .normal)
        button.setImage(tintedClearImage, for: .highlighted)
        lastTintColor = newTintColor
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}

extension TextField {
    fileprivate func syncToPlaceholderColor() {
        if let placeholderColor = self.placeholderColor ?? type(of: self).placeholderColor {
            if let placeholder = placeholder {
                let a = placeholder§
                a.foregroundColor = placeholderColor
                attributedPlaceholder = a
            }
        }
    }
}
