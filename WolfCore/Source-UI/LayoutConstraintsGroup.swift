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
    private let identifier: String?

    public init(constraints: [NSLayoutConstraint], active: Bool = false, identifier: String? = nil) {
        self.constraints = constraints
        self.active = active
        self.identifier = identifier
        syncToActive()
    }

    private var lastActive = false

    public var active = false {
        didSet {
            syncToActive()
        }
    }

    private func syncToActive() {
        guard lastActive != active else { return }
        lastActive = active
        switch active {
        case true:
            logTrace("Activating Constraints \(identifier ?? ""): \(constraints)", obj: self, group: layoutLogGroup)
            activateConstraints(constraints)
        case false:
            logTrace("Deactivating Constraints \(identifier ?? ""): \(constraints)", obj: self, group: layoutLogGroup)
            NSLayoutConstraint.deactivateConstraints(constraints)
        }
    }

    deinit {
        logTrace("\(self) deinit", obj: self, group: layoutLogGroup)
        active = false
    }
}
