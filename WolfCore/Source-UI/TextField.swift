//
//  TextField.swift
//  WolfCore
//
//  Created by Robert McNally on 6/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class TextField: UITextField, Skinnable {
    public var skinChangedAction: SkinChangedAction!
    public static var placeholderColor: UIColor?
    public var placeholderColor: UIColor?
    var tintedClearImage: UIImage?
    var lastTintColor: UIColor?

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
        ~~self
        setup()
        setupSkinnable()
   }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }

    open func setup() {
    }

    open func updateAppearance() {
        syncToTintColor()
        syncToPlaceholderColor()
    }

    open override var placeholder: String? {
        didSet {
            syncToPlaceholderColor()
        }
    }
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
        button.setImage(tintedClearImage, for: [])
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
