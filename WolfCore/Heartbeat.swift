//
//  Heartbeat.swift
//  WolfCore
//
//  Created by Robert McNally on 12/15/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

public class Heartbeat {
    var canceler: Canceler?
    let interval: NSTimeInterval
    let expired: DispatchBlock
    
    public init(interval: NSTimeInterval, expired: DispatchBlock) {
        self.interval = interval
        self.expired = expired
        reset()
    }
    
    deinit {
        canceler?.cancel()
    }
    
    private func reset() {
        canceler?.cancel()
        canceler = dispatchOnMainAfterDelay(interval) { [unowned self] canceler in
            self.expired()
        }
    }
}
