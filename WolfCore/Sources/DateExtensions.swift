//
//  DateExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/12/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

extension Date {
    public func lastDayOfMonth() -> Date {
        let calendar = Calendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)!
        let dayCount = dayRange.count
        #if os(Linux)
            let comp = calendar.dateComponents([.year, .month, .day], from: self)!
            comp.day = dayCount
        #else
            var comp = calendar.dateComponents([.year, .month, .day], from: self)
            comp.day = dayCount
        #endif
        return calendar.date(from: comp)!
    }
}


// Provide for converting dates to and from ISO8601 format.
// Example: "1965-05-15T00:00:00.0Z"

private var _iso8601DateFormatter: DateFormatter! = nil

extension Date {
    public static var iso8601Formatter: DateFormatter {
        if _iso8601DateFormatter == nil {
            _iso8601DateFormatter = DateFormatter()
            _iso8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
        }
        return _iso8601DateFormatter
    }

    public var iso8601: String {
        return type(of: self).iso8601Formatter.string(from: self)
    }
}

#if os(Linux)
    extension Date {
        public convenience init(iso8601: String) throws {
            if let date = type(of: self).iso8601Formatter.date(from: iso8601) {
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

    extension Date {
        public convenience init(millisecondsSince1970 ms: Double) {
            self.init(timeIntervalSince1970: ms / 1000.0)
        }

        public var millisecondsSince1970: Double {
            return timeIntervalSince1970 * 1000.0
        }
    }
#endif

#if !os(Linux)
    extension Date {
        public init(iso8601: String) throws {
            if let date = type(of: self).iso8601Formatter.date(from: iso8601) {
                let timeInterval = date.timeIntervalSinceReferenceDate
                self.init(timeIntervalSinceReferenceDate: timeInterval)
            } else {
                throw ValidationError(message: "Invalid ISO8601 format", violation: "8601Format")
            }
        }

        public init(year: Int, month: Int, day: Int) throws {
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

    extension Date {
        public init(millisecondsSince1970 ms: Double) {
            self.init(timeIntervalSince1970: ms / 1000.0)
        }

        public var millisecondsSince1970: Double {
            return timeIntervalSince1970 * 1000.0
        }
    }
#endif
