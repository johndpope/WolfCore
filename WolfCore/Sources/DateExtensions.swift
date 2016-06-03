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

    public convenience init(iso8601: String) throws {
        if let date = self.dynamicType.iso8601Formatter.dateFromString(iso8601) {
            let timeInterval = date.timeIntervalSinceReferenceDate
            self.init(timeIntervalSinceReferenceDate: timeInterval)
        } else {
            throw ValidationError(message: "Invalid ISO8601 format", violation: "8601Format")
        }
    }

    public convenience init(year: Int, month: Int, day: Int) throws {
        guard year > 0 else {
            throw ValidationError(message: "Invalid year", violation: "dateFormat")
        }
        guard 1...12 ~= month else {
            throw ValidationError(message: "Invalid month", violation: "dateFormat")
        }
        guard 1...31 ~= day else {
            throw ValidationError(message: "Invalid day", violation: "dateFormat")
        }
        let yearString = "\(year)"
        let monthString = "\(month)".padded(toCount: 2, withCharacter: "0")
        let dayString = "\(day)".padded(toCount: 2, withCharacter: "0")
        try self.init(iso8601: "\(yearString)-\(monthString)-\(dayString)T00:00:00.0Z")
    }
}

extension NSDate {
    public convenience init(millisecondsSince1970 ms: Double) {
        self.init(timeIntervalSince1970: ms / 1000.0)
    }

    public var millisecondsSince1970: Double {
        return timeIntervalSince1970 * 1000.0
    }
}
