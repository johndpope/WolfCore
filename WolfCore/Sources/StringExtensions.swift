//
//  StringExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/13/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import Foundation
#endif


// Provide concise versions of NSLocalizedString.

#if os(iOS) || os(OSX) || os(tvOS)
extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public func localized(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
#endif


// Provide conversions of String to and from Bytes (UTF-8 encoding)

extension String {
    public var bytes: Bytes {
        var bytes = Bytes()
        for c in self.utf8 {
            bytes.append(c)
        }
        return bytes
    }

    public init?(bytes: Bytes) {
        var bytes = bytes
        bytes.append(0)
        let s = withUnsafePointer(&bytes) {
            String.fromCString(UnsafePointer($0))
        }
        if let s = s {
            self.init(s)
        } else {
            return nil
        }
    }
}


#if os(iOS) || os(OSX) || os(tvOS)
// Provide conversions of strings to and from JSON objects

extension String {
    public var json: JSONObject? {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return data.json
        } else {
            return nil
        }
    }

    public init?(json: JSONObject) {
        if let data = NSData(json: json) {
            if let str = data.string {
                self.init(str)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
#endif

#if os(iOS) || os(OSX) || os(tvOS)
public extension NSString {
    var cgFloatValue: CGFloat {
        get {
            return CGFloat(self.doubleValue)
        }
    }
}
#endif
