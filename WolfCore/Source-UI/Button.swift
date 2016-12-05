//
//  Button.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

open class Button: UIButton {
    private var skinChangedAction: SkinChangedAction!

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
        setTitle(title(for: [])?.localized(onlyIfTagged: true), for: [])
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
        ~~self
        setup()
        skinChangedAction = SkinChangedAction(for: self) { [unowned self] in
            self.updateAppearance()
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    /// Override in subclasses
    open func setup() { }

    /// Override in subclasses
    open func updateAppearance() { }

    private func removeCustomView() {
        customView?.removeFromSuperview()
    }

    private func addCustomView(constraintsIdentifier identifier: String? = nil) {
        guard let customView = customView else { return }

        addSubview(customView)
        customView.makeTransparent()
        customView.constrainToSuperview(identifier: identifier ?? "button")
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
