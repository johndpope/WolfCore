//
//  LinuxCompatibility.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/16/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

//public typealias Calendar = NSCalendar
//public typealias Data = NSData
//public typealias Date = NSDate
//public typealias DateComponents = NSDateComponents
//public typealias DateFormatter = NSDateFormatter
//public typealias HTTPURLResponse = NSHTTPURLResponse
//public typealias JSONSerialization = NSJSONSerialization
//public typealias RegularExpression = NSRegularExpression
//public typealias TextCheckingResult = NSTextCheckingResult
//public typealias TimeZone = NSTimeZone
//public typealias URL = NSURL
//public typealias URLRequest = NSURLRequest
//public typealias URLSession = NSURLSession
//public typealias UUID = NSUUID
//
//extension Data {
//    public var count: Int {
//        return Int(length)
//    }
//
//    public convenience init(bytes: Bytes, count: Int) {
//        self.init(bytesNoCopy: &bytes, length: count)
//    }
//
//    public convenience init?(base64Encoded string: String) {
//        self.init(base64Encoding: string)
//    }
//
//    public func copyBytes(to bytes: UnsafeMutablePointer<UInt8>, count: Int) {
//        getBytes(bytes, length: count)
//    }
//
//    public subscript(bounds: Range<Int>) -> MutableRandomAccessSlice<Data> {
//        return MutableRandomAccessSlice(base: self, bounds: bounds)
//    }
//}
//
//extension DateFormatter {
//    public func date(from string: String) -> Date? {
//        return self.dateFromString(string)
//    }
//}
//
//extension Calendar {
//    public static func current() -> Calendar {
//        return self.currentCalendar()
//    }
//}
//
//extension URLSession {
//    public static func shared() -> URLSession {
//        return self.sharedSession()
//    }
//}
