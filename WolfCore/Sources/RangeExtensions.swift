//
//  RangeExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSRange {
    public var isFound: Bool {
        return location != Int(Foundation.NSNotFound)
    }
    
    public var isNotFound: Bool {
        return location == Int(Foundation.NSNotFound)
    }
}
