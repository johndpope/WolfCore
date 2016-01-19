//
//  TextCheckingResultExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSTextCheckingResult {
    public var captureRanges: [NSRange] {
        var result = [NSRange]()
        for i in 1..<self.numberOfRanges {
            result.append(self.rangeAtIndex(i))
        }
        return result
    }
}
