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
        if followsTintColor {
            textColor = tintColor ?? .Black
            tintClearImage()
        }
    }

    private func tintClearImage() {
        let buttons: [UIButton] = self.descendentViews(ofClass: UIButton.self)
        if !buttons.isEmpty {
            let button = buttons[0]
            if let image = button.imageForState(.Highlighted) {
                if tintedClearImage == nil {
                    tintedClearImage = image.tintWithColor(tintColor)
                }
                button.setImage(tintedClearImage, forState: .Normal)
                button.setImage(tintedClearImage, forState: .Highlighted)
            }
        }
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}
