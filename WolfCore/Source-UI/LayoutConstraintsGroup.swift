//
//  LayoutConstraintsGroup.swift
//  WolfCore
//
//  Created by Robert McNally on 7/7/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

public class LayoutConstraintsGroup {
    private let constraints: [NSLayoutConstraint]
    private let debugName: String?

    public init(constraints: [NSLayoutConstraint], active: Bool = false, debugName: String? = nil) {
        self.constraints = constraints
        self.active = active
        self.debugName = debugName
        syncToActive()
    }

    public var active: Bool = false {
        didSet {
            syncToActive()
        }
    }

    private func syncToActive() {
        switch active {
        case true:
            NSLayoutConstraint.activateConstraints(constraints)
        case false:
            NSLayoutConstraint.deactivateConstraints(constraints)
        }
    }

    deinit {
        active = false
    }
}
