//
//  DispatchUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/9/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public typealias BoolBlock = (Bool) -> Void

public let mainQueue = DispatchQueue.main
public let backgroundQueue = DispatchQueue(label: "background", attributes: [.concurrent], target: nil)

private func _dispatch(onQueue queue: DispatchQueue, cancelable: Cancelable, _ f: @escaping CancelableBlock) {
    queue.async {
        f(cancelable)
    }
}

private func _dispatch(onQueue queue: DispatchQueue, afterDelay delay: TimeInterval, cancelable: Cancelable, f: @escaping CancelableBlock) {
    queue.asyncAfter(deadline: DispatchTime.now() + delay) {
        f(cancelable)
    }
}

// Dispatch a block asynchronously on the give queue. This method returns immediately. Blocks dispatched asynchronously will be executed at some time in the future.
@discardableResult public func dispatch(onQueue queue: DispatchQueue, _ f: @escaping Block) -> Cancelable {
    let canceler = Canceler()
    _dispatch(onQueue: queue, cancelable: canceler) { cancelable in
        if !cancelable.isCanceled {
            f()
        }
    }
    return canceler
}

// Dispatch a block asynchronously on the main queue.
@discardableResult public func dispatchOnMain(f: @escaping Block) -> Cancelable {
    return dispatch(onQueue: mainQueue, f)
}

// Dispatch a block asynchronously on the background queue.
@discardableResult public func dispatchOnBackground(f: @escaping Block) -> Cancelable {
    return dispatch(onQueue: backgroundQueue, f)
}

// After the given delay, dispatch a block asynchronously on the given queue. Returns a Canceler object that, if its <isCanceled> attribute is true when the dispatch time arrives, the block will not be executed.
@discardableResult public func dispatch(onQueue queue: DispatchQueue, afterDelay delay: TimeInterval, f: @escaping Block) -> Cancelable {
    let canceler = Canceler()
    _dispatch(onQueue: queue, afterDelay: delay, cancelable: canceler) { canceler in
        if !canceler.isCanceled {
            f()
        }
    }
    return canceler
}

// After the given delay, dispatch a block asynchronously on the main queue. Returns a Canceler object that, if its <isCanceled> attribute is true when the dispatch time arrives, the block will not be executed.
@discardableResult public func dispatchOnMain(afterDelay delay: TimeInterval, f: @escaping Block) -> Cancelable {
    return dispatch(onQueue: mainQueue, afterDelay: delay, f: f)
}

// After the given delay, dispatch a block asynchronously on the background queue. Returns a Canceler object that, if its <isCanceled> attribute is true when the dispatch time arrives, the block will not be executed.
@discardableResult public func dispatchOnBackground(afterDelay delay: TimeInterval, f: @escaping Block) -> Cancelable {
    return dispatch(onQueue: backgroundQueue, afterDelay: delay, f: f)
}

private func _dispatchRepeated(onQueue queue: DispatchQueue, atInterval interval: TimeInterval, cancelable: Cancelable, _ f: @escaping CancelableBlock) {
    _dispatch(onQueue: queue, afterDelay: interval, cancelable: cancelable) { cancelable in
        if !cancelable.isCanceled {
            f(cancelable)
        }
        if !cancelable.isCanceled {
            _dispatchRepeated(onQueue: queue, atInterval: interval, cancelable: cancelable, f)
        }
    }
}

// Dispatch the block immediately, and then again after each interval passes. An interval of 0.0 means dispatch the block only once.
@discardableResult public func dispatchRepeated(onQueue queue: DispatchQueue, atInterval interval: TimeInterval, f: @escaping CancelableBlock) -> Cancelable {
    let canceler = Canceler()
    _dispatch(onQueue: queue, cancelable: canceler) { cancelable in
        if !cancelable.isCanceled {
            f(cancelable)
        }
        if interval > 0.0 {
            if !cancelable.isCanceled {
                _dispatchRepeated(onQueue: queue, atInterval: interval, cancelable: cancelable, f)
            }
        }
    }
    return canceler
}

@discardableResult public func dispatchRepeatedOnMain(atInterval interval: TimeInterval, f: @escaping CancelableBlock) -> Cancelable {
    return dispatchRepeated(onQueue: mainQueue, atInterval: interval, f: f)
}

@discardableResult public func dispatchRepeatedOnBackground(atInterval interval: TimeInterval, f: @escaping CancelableBlock) -> Cancelable {
    return dispatchRepeated(onQueue: backgroundQueue, atInterval: interval, f: f)
}
