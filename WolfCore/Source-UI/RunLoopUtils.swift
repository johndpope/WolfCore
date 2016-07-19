//
//  RunLoopUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension RunLoop {
    public func runOnce() {
        run(until: NSDate.distantPast)
    }
}
