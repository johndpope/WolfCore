//
//  Hideable.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/11/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public protocol Hideable: class {
    var isHidden: Bool { get set }
}

extension Hideable {
    public func show() {
        isHidden = false
    }

    public func hide() {
        isHidden = true
    }

    public func showIf(_ condition: Bool) {
        isHidden = !condition
    }

    public func hideIf(_ condition: Bool) {
        isHidden = condition
    }
}

public protocol AnimatedHideable: Hideable {
    var alpha: CGFloat { get set }
}

extension AnimatedHideable {
    public func hide(animated: Bool) {
        guard !isHidden else { return }
        dispatchAnimated(
            animated,
            animations: {
                self.alpha = 0
        },
            completion: { _ in
                self.hide()
        }
        )
    }

    public func show(animated: Bool) {
        guard isHidden else { return }
        dispatchAnimated(animated) {
            self.show()
            self.alpha = 1
        }
    }

    public func showIf(_ condition: Bool, animated: Bool) {
        if condition {
            show(animated: animated)
        } else {
            hide(animated: animated)
        }
    }

    public func hideIf(_ condition: Bool, animated: Bool) {
        if condition {
            hide(animated: animated)
        } else {
            show(animated: animated)
        }
    }
}
