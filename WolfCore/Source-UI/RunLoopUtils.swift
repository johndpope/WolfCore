//
//  RunLoopUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSRunLoop {
    public func runOnce() {
        runUntilDate(NSDate.distantPast())
    }
}
