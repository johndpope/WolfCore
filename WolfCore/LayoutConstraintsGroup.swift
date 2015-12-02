//
//  LayoutConstraintsGroup.swift
//  WolfCore
//
//  Created by Robert McNally on 7/7/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

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
//            print("Activating Constraints \(debugName ?? ""): \(constraints)")
            NSLayoutConstraint.activateConstraints(constraints)
        case false:
//            print("Deactivating Constraints \(debugName ?? ""): \(constraints)")
            NSLayoutConstraint.deactivateConstraints(constraints)
        }
    }
    
    deinit {
//        print("\(self) deinit")
        active = false
    }
}
