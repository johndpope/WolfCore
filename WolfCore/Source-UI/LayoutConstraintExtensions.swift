//
//  LayoutConstraintExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 12/13/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

extension NSLayoutConstraint {
    public func activate() {
        activateConstraints(self)
    }

    public func deactivate() {
        deactivateConstraints(self)
    }
}
