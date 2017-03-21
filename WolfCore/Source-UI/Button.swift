//
//  Button.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

open class Button: UIButton, Skinnable {
    private var controlAction: ControlAction<Button>!

    public var action: Block? {
        didSet {
            if action != nil {
                controlAction = addTouchUpInsideAction(to: self) { [unowned self] _ in
                    self.action?()
                }
            } else {
                controlAction = nil
            }
        }
    }

    @IBOutlet var customView: UIView? {
        willSet {
            removeCustomView()
        }
        didSet {
            addCustomView()
        }
    }

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
        setTitleColor(skin.buttonTintColor, for: .normal)
        setTitleColor(skin.buttonHighlightedTintColor, for: .highlighted)
        setTitleColor(skin.buttonDisabledColor, for: .disabled)

        guard let titleLabel = titleLabel, let fontStyle = skin.fontStyles[.buttonTitle] else { return }
        titleLabel.font = fontStyle.font
    }

    open func setup() { }

    private func removeCustomView() {
        customView?.removeFromSuperview()
    }

    private func addCustomView(constraintsIdentifier identifier: String? = nil) {
        guard let customView = customView else { return }

        addSubview(customView)
        customView.constrainFrame(identifier: identifier ?? "button")
        customView.isUserInteractionEnabled = false
    }

    private func syncToHighlighted() {
        guard let customView = self.customView else { return }
        let isHighlighted = self.isHighlighted
        customView.tintColor = titleColor(for: isHighlighted ? .highlighted : [])!.withAlphaComponent(isHighlighted ? 0.4 : 1.0)
        customView.forViewsInHierarchy { view -> Bool in
            (view as? UIImageView)?.isHighlighted = isHighlighted
            return false
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            syncToHighlighted()
        }
    }
}
