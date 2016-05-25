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
        translatesAutoresizingMaskIntoConstraints = false
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
        dispatchAnimated(duration: 0.1) {
            self.customView?.tintColor = self.titleColorForState(self.highlighted ? .Highlighted : .Normal)!.colorWithAlphaComponent(self.highlighted ? 0.4 : 1.0)
        }
    }

    public override var highlighted: Bool {
        didSet {
            syncToHighlighted()
        }
    }
}
