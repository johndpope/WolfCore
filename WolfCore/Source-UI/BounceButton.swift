//
//  BounceButton.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class BounceButton: Button {
    @IBInspectable public var waitForBounce: Bool = true

    private lazy var bounceAnimation: BounceAnimation = { return BounceAnimation(view: self) }()
    private var inSetup: Bool = false
    private weak var touchUpInsideTarget: AnyObject?
    private var touchUpInsideAction: Selector!

    public override var isHighlighted: Bool {
        didSet(oldHighlighted) {
            bounceAnimation.animate(oldHighlighted: oldHighlighted, newHighlighted: isHighlighted)
        }
    }

    private func performTouchUpInsideAction() {
        touchUpInsideTarget?.performSelector(onMainThread: touchUpInsideAction, with: nil, waitUntilDone: false)
    }

    public override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        if !inSetup && controlEvents == .touchUpInside {
            touchUpInsideTarget = target as AnyObject
            touchUpInsideAction = action
        } else {
            super.addTarget(target, action: action, for: controlEvents)
        }
    }

    public override func setup() {
        super.setup()

        inSetup = true
        defer { inSetup = false }

        action = { [unowned self] in
            self.bounceAnimation.animateRelease() { [unowned self] in
                if self.waitForBounce {
                    self.performTouchUpInsideAction()
                }
            }
            if !self.waitForBounce {
                self.performTouchUpInsideAction()
            }
        }
    }
}
