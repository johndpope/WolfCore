//
//  ISO8601.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

private var iso8601Formatter = ISO8601.formatter()

public class ISO8601 {
    private static func formatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
        return formatter
    }

    public static func encode(date: NSDate) -> String {
        return iso8601Formatter.stringFromDate(date)
    }

    public static func decode(string: String) throws -> NSDate {
        if let date = iso8601Formatter.dateFromString(string) {
            let timeInterval = date.timeIntervalSinceReferenceDate
            return NSDate(timeIntervalSinceReferenceDate: timeInterval)
        } else {
            throw ValidationError(message: "Invalid ISO8601 string: \(string).", identifier: "iso8601Format")
        }
    }
}
