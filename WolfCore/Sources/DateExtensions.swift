//
//  DateExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

extension NSDate {
    public func lastDayOfMonth() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dayRange = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        let dayCount = dayRange.length
        let comp = calendar.components([.Year, .Month, .Day], fromDate: self)
        
        comp.day = dayCount
        
        return calendar.dateFromComponents(comp)!
    }
}

// Make dates comparable with comparison operators.

extension NSDate: Comparable {
}

public func == (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == .OrderedSame
}

public func < (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == .OrderedAscending
}
