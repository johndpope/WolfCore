//
//  RegularExpressionExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    public func firstMatch(inString string: String, options: NSMatchingOptions, range: StringRange? = nil) -> NSTextCheckingResult? {
        let range = range ?? string.range
        let nsRange = string.nsRange(fromRange: range)!
        return firstMatchInString(string, options: options, range: nsRange)
    }

    public func matchedSubstringsInString(string: String, options: NSMatchingOptions = [], range: StringRange? = nil) -> [String]? {
        var result: [String]! = nil
        if let textCheckingResult = self.firstMatch(inString: string, options: options, range: range) {
            result = [String]()
            for range in textCheckingResult.captureRanges(inString: string) {
                let matchText = string.substringWithRange(range)
                result.append(matchText)
            }
        }
        return result
    }
}
