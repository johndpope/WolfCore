//
//  Hideable.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/11/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

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
