//
//  RegularExpressionExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    public func matchedSubstringsInString(string: String, options: NSMatchingOptions = [], range: NSRange? = nil) -> [String]? {
        // let nsString = string as NSString
        let nsString = NSString(string: string)
        let range: NSRange = range ?? NSRange(0..<nsString.length)
        var result: [String]! = nil
        if let textCheckingResult = self.firstMatchInString(string, options: options, range: range) {
            result = [String]()
            for range in textCheckingResult.captureRanges {
                if range.isFound {
                    let matchText = nsString.substringWithRange(range)
                    result.append(matchText)
                }
            }
        }
        return result
    }
}
