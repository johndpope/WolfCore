//
//  LayoutConstraintsGroup.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/7/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

extension Log.GroupName {
    public static let layout = Log.GroupName("layout")
}

public class LayoutConstraintsGroup {
    private let constraints: [NSLayoutConstraint]
    private let identifier: String?

    public init(constraints: [NSLayoutConstraint], active: Bool = false, identifier: String? = nil) {
        self.constraints = constraints
        self.isActive = active
        self.identifier = identifier
        syncToActive()
    }

    private var lastActive = false

    public var isActive = false {
        didSet {
            syncToActive()
        }
    }

    private func syncToActive() {
        guard lastActive != isActive else { return }
        lastActive = isActive
        switch isActive {
        case true:
            logTrace("Activating Constraints \(identifier ?? ""): \(constraints)", obj: self, group: .layout)
            activateConstraints(constraints)
        case false:
            logTrace("Deactivating Constraints \(identifier ?? ""): \(constraints)", obj: self, group: .layout)
            deactivateConstraints(constraints)
        }
    }

    deinit {
        logTrace("\(self) deinit", obj: self, group: .layout)
        isActive = false
    }
}
