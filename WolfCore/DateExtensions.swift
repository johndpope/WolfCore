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


// Provide for converting dates to and from ISO8601 format.
// Example: "1965-05-15T00:00:00.0Z"

private var _iso8601DateFormatter: NSDateFormatter! = nil

extension NSDate {
    public class var iso8601Formatter: NSDateFormatter {
        if _iso8601DateFormatter == nil {
            _iso8601DateFormatter = NSDateFormatter()
            _iso8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
        }
        return _iso8601DateFormatter
    }
    
    public var iso8601: String {
        return self.dynamicType.iso8601Formatter.stringFromDate(self)
    }
    
    public convenience init?(iso8601: String) {
        if let date = self.dynamicType.iso8601Formatter.dateFromString(iso8601) {
            let timeInterval = date.timeIntervalSinceReferenceDate
            self.init(timeIntervalSinceReferenceDate: timeInterval)
        } else {
            return nil
        }
    }
}