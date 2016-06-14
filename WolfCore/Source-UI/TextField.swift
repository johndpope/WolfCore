//
//  TextField.swift
//  WolfCore
//
//  Created by Robert McNally on 6/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class TextField: UITextField {
    private var tintedClearImage: UIImage?
    private var lastTintColor: UIColor?

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
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }

    /// Override in subclasses
    public func setup() {
    }

    /// Override in subclasses
    public func updateAppearance() {
        syncToTintColor()
    }
}

extension TextField {
    private func syncToTintColor() {
        guard followsTintColor else { return }
        textColor = tintColor ?? .Black
        tintClearImage()
    }

    private func tintClearImage() {
        guard followsTintColor else { return }
        guard lastTintColor != tintColor else { return }
        let buttons: [UIButton] = self.descendentViews(ofClass: UIButton.self)
        guard !buttons.isEmpty else { return }
        let button = buttons[0]
        guard let image = button.imageForState(.Highlighted) else { return }
        tintedClearImage = image.tinted(withColor: tintColor)
        button.setImage(tintedClearImage, forState: .Normal)
        button.setImage(tintedClearImage, forState: .Highlighted)
        lastTintColor = tintColor
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}
