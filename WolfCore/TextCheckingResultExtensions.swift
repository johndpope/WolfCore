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
        for var i = 1; i < self.numberOfRanges; ++i {
            result.append(self.rangeAtIndex(i))
        }
        return result
    }
}
