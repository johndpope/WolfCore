//
//  LayoutConstraintExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 12/13/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    public func activate() {
        NSLayoutConstraint.activateConstraints([self])
    }
    
    public func deactivate() {
        NSLayoutConstraint.deactivateConstraints([self])
    }
}
