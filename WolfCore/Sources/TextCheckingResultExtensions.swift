//
//  TextCheckingResultExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSTextCheckingResult {
    public func range(atIndex index: Int, inString string: String) -> StringRange {
        return string.range(fromNSRange: rangeAtIndex(index))!
    }

    public func captureRanges(inString string: String) -> [StringRange] {
        var result = [StringRange]()
        for i in 1 ..< numberOfRanges {
            result.append(range(atIndex: i, inString: string))
        }
        return result
    }
}

extension NSTextCheckingResult {
    public func get(atIndex index: Int, inString string: String) -> (StringRange, String) {
        let range = self.range(atIndex: index, inString: string)
        let text = string.substringWithRange(range)
        return (range, text)
    }
}
