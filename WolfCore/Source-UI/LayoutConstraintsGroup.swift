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

public let layoutLogGroup = "Layout"

public class LayoutConstraintsGroup {
    private let constraints: [NSLayoutConstraint]
    private let debugName: String?

    public init(constraints: [NSLayoutConstraint], active: Bool = false, debugName: String? = nil) {
        self.constraints = constraints
        self.active = active
        self.debugName = debugName
        syncToActive()
    }

    public var active = false {
        didSet {
            syncToActive()
        }
    }

    private func syncToActive() {
        switch active {
        case true:
            logTrace("Activating Constraints \(debugName ?? ""): \(constraints)", obj: self, group: layoutLogGroup)
            activateConstraints(constraints)
        case false:
            logTrace("Deactivating Constraints \(debugName ?? ""): \(constraints)", obj: self, group: layoutLogGroup)
            NSLayoutConstraint.deactivateConstraints(constraints)
        }
    }

    deinit {
        logTrace("\(self) deinit", obj: self, group: layoutLogGroup)
        active = false
    }
}
