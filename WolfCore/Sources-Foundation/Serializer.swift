//
//  Serializer.swift
//  WolfCore
//
//  Created by Robert McNally on 12/9/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

let serializerKey: String = "Serializer"
var nextQueueContext: Int = 1

public class Serializer {
    let queue: DispatchQueue
    let queueContext: NSNumber

    public init(name: NSString? = nil) {
        self.queue = dispatch_queue_create(name?.UTF8String ?? nil, DISPATCH_QUEUE_SERIAL)
        nextQueueContext += 1
        self.queueContext = NSNumber(integer: nextQueueContext)
//        dispatch_queue_set_specific_glue(self.queue, serializerKey, self.queueContext)
    }

    var isExecutingOnMyQueue: Bool {
        get {
//            let context = dispatch_get_specific_glue(serializerKey)
//            return context === self.queueContext
            return false
        }
    }

    public func dispatch(f: DispatchBlock) {
        if isExecutingOnMyQueue {
            f()
        } else {
            dispatchSync(onQueue: queue, f)
        }
    }

    public func dispatchWithReturn<🍒>(f: () -> 🍒) -> 🍒 {
        var result: 🍒!

        if isExecutingOnMyQueue {
            result = f()
        } else {
            dispatchSync(onQueue: queue) {
                result = f()
            }
        }

        return result!
    }

    public func dispatchOnMain(f: DispatchBlock) {
        dispatchSyncOnMain(f)
    }

    public func dispatchOnMainWithReturn<🍒>(f: () -> 🍒) -> 🍒 {
        var result: 🍒!

        dispatchSyncOnMain() {
            result = f()
        }

        return result!
    }
}
