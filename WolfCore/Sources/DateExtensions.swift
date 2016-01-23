//
//  DateExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

// Make dates comparable with comparison operators.

extension NSDate: Comparable {
}

public func == (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == .OrderedSame
}

public func < (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == .OrderedAscending
}
