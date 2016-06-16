//
//  Button.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class Button: UIButton {
    @IBOutlet var customView: UIView? {
        willSet {
            removeCustomView()
        }
        didSet {
            addCustomView()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        let t = title(for: [])?.localized(onlyIfTagged: true)
        setTitle(t, for: [])
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
    }

    // Override in subclasses
    public func setup() { }

    func removeCustomView() {
        customView?.removeFromSuperview()
    }

    func addCustomView(constraintsIdentifier identifier: String? = nil) {
        guard let customView = customView else { return }

        addSubview(customView)
        customView.makeTransparent()
        customView.constrainToSuperview(identifier: identifier ?? "button")
        customView.isUserInteractionEnabled = false
    }

    func syncToHighlighted() {
        if let customView = self.customView {
            let isHighlighted = self.isHighlighted
            customView.tintColor = titleColor(for: isHighlighted ? .highlighted : [])!.withAlphaComponent(isHighlighted ? 0.4 : 1.0)
            customView.forViewsInHierachy { view -> Bool in
                (view as? UIImageView)?.isHighlighted = isHighlighted
                return false
            }
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            syncToHighlighted()
        }
    }
}
