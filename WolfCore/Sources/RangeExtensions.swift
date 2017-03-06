//
//  RangeExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSRange {
    public var isFound: Bool {
        return location != NSNotFound
    }

    public var isNotFound: Bool {
        return location == NSNotFound
    }
}
