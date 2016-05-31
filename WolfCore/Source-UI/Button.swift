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
        setTitle(titleForState(.Normal)?.localized(onlyIfTagged: true), forState: .Normal)
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

    func addCustomView() {
        guard let customView = customView else { return }

        addSubview(customView)
        customView.makeTransparent()
        customView.constrainToSuperview()
        customView.userInteractionEnabled = false
    }

    func syncToHighlighted() {
        let highlighted = self.highlighted
        if let customView = self.customView {
            customView.tintColor = self.titleColorForState(highlighted ? .Highlighted : .Normal)!.colorWithAlphaComponent(highlighted ? 0.4 : 1.0)
            customView.forViewsInHierachy { view in
                (view as? UIImageView)?.highlighted = highlighted
            }
        }
    }

    public override var highlighted: Bool {
        didSet {
            syncToHighlighted()
        }
    }
}
