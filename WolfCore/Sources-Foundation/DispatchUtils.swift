//
//  DispatchUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/9/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

//#if os(Linux)
//    import CDispatch
//    public typealias dispatch_block_t = () -> Void
//#endif

// #define DISPATCH_QUEUE_CONCURRENT \
                // DISPATCH_GLOBAL_OBJECT(dispatch_queue_attr_t, \
                // _dispatch_queue_attr_concurrent)

public let mainQueue = DispatchQueue.main
public let backgroundQueue = DispatchQueue(label: "background", attributes: [.concurrent], target: nil)

// A utility function to convert a time since now as a Double (TimeInterval) representing a number of seconds to a dispatch_time_t used by GCD.
public func dispatchTimeSinceNow(offsetInSeconds: TimeInterval) -> DispatchTime {
    return DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(offsetInSeconds * 1000))
}

// Dispatch a block synchronously on the given queue. Blocks dispatched synchronously block the current thread until they complete.
//
// Example:
//   print("1")
//   dispatchSyncOn(queue: backgroundQueue) {
//     print("2")
//   }
//   print("3")
//
// Since the dispatch is synchronous, this example is guaranteed to print:
// 1
// 2
// 3

func _dispatch(onQueue queue: DispatchQueue, canceler: Canceler, _ f: @escaping CancelableBlock) {
    queue.async {
        f(canceler)
    }
}

// Dispatch a block asynchronously on the give queue. This method returns immediately. Blocks dispatched asynchronously will be executed at some time in the future.
@discardableResult public func dispatch(onQueue queue: DispatchQueue, _ f: @escaping Block) -> Canceler {
    let canceler = Canceler()
    _dispatch(onQueue: queue, canceler: canceler) { canceler in
        if !canceler.isCanceled {
            f()
        }
    }
    return canceler
}

// Dispatch a block asynchronously on the main queue.
@discardableResult public func dispatchOnMain(f: @escaping Block) -> Canceler {
    return dispatch(onQueue: mainQueue, f)
}

// Dispatch a block asynchronously on the background queue.
@discardableResult public func dispatchOnBackground(f: @escaping Block) -> Canceler {
    return dispatch(onQueue: backgroundQueue, f)
}

func _dispatch(onQueue queue: DispatchQueue, afterDelay delay: TimeInterval, c: Canceler, f: @escaping CancelableBlock) {
    queue.asyncAfter(deadline: dispatchTimeSinceNow(offsetInSeconds: delay)) {
        f(c)
    }
}

// After the given delay, dispatch a block asynchronously on the given queue. Returns a Canceler object that, if its <isCanceled> attribute is true when the dispatch time arrives, the block will not be executed.
@discardableResult public func dispatch(onQueue queue: DispatchQueue, afterDelay delay: TimeInterval, f: @escaping Block) -> Canceler {
    let canceler = Canceler()
    _dispatch(onQueue: queue, afterDelay: delay, c: canceler) { canceler in
        if !canceler.isCanceled {
            f()
        }
    }
    return canceler
}

// After the given delay, dispatch a block asynchronously on the main queue. Returns a Canceler object that, if its <isCanceled> attribute is true when the dispatch time arrives, the block will not be executed.
@discardableResult public func dispatchOnMain(afterDelay delay: TimeInterval, f: @escaping Block) -> Canceler {
    return dispatch(onQueue: mainQueue, afterDelay: delay, f: f)
}

// After the given delay, dispatch a block asynchronously on the background queue. Returns a Canceler object that, if its <isCanceled> attribute is true when the dispatch time arrives, the block will not be executed.
@discardableResult public func dispatchOnBackground(afterDelay delay: TimeInterval, f: @escaping Block) -> Canceler {
    return dispatch(onQueue: backgroundQueue, afterDelay: delay, f: f)
}

func _dispatchRepeated(onQueue queue: DispatchQueue, atInterval interval: TimeInterval, canceler: Canceler, _ f: @escaping CancelableBlock) {
    _dispatch(onQueue: queue, afterDelay: interval, c: canceler) { canceler in
        if !canceler.isCanceled {
            f(canceler)
        }
        if !canceler.isCanceled {
            _dispatchRepeated(onQueue: queue, atInterval: interval, canceler: canceler, f)
        }
    }
}

// Dispatch the block immediately, and then again after each interval passes. An interval of 0.0 means dispatch the block only once.
@discardableResult public func dispatchRepeated(onQueue queue: DispatchQueue, atInterval interval: TimeInterval, f: @escaping CancelableBlock) -> Canceler {
    let canceler = Canceler()
    _dispatch(onQueue: queue, canceler: canceler) { canceler in
        if !canceler.isCanceled {
            f(canceler)
        }
        if interval > 0.0 {
            if !canceler.isCanceled {
                _dispatchRepeated(onQueue: queue, atInterval: interval, canceler: canceler, f)
            }
        }
    }
    return canceler
}

@discardableResult public func dispatchRepeatedOnMain(atInterval interval: TimeInterval, f: @escaping CancelableBlock) -> Canceler {
    return dispatchRepeated(onQueue: mainQueue, atInterval: interval, f: f)
}

@discardableResult public func dispatchRepeatedOnBackground(atInterval interval: TimeInterval, f: @escaping CancelableBlock) -> Canceler {
    return dispatchRepeated(onQueue: backgroundQueue, atInterval: interval, f: f)
}
