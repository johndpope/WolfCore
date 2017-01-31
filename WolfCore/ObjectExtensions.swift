//
//  ObjectExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/30/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

private var debugIdentifierKey = "debugIdentifier"

extension NSObject {
    public var debugIdentifier: String? {
        get {
            return getAssociatedValue(for: &debugIdentifierKey)
        }

        set {
            setAssociatedValue(newValue, for: &debugIdentifierKey)
        }
    }
}
