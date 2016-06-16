//
//  Serializer.swift
//  WolfCore
//
//  Created by Robert McNally on 12/9/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

private typealias SerializerKey = DispatchSpecificKey<Int>
private let serializerKey = SerializerKey()
private var nextQueueContext: Int = 1

public class Serializer {
    let queue: DispatchQueue
    let queueContext: Int

    public init(name: String) {
        queue = DispatchQueue(label: name, attributes: [.serial])
        queueContext = nextQueueContext
        queue.setSpecific(key: serializerKey, value: queueContext)
        nextQueueContext += 1
    }

    var isExecutingOnMyQueue: Bool {
        get {
            guard let context = DispatchQueue.getSpecific(key: serializerKey) else { return false }
            return context == queueContext
        }
    }

    public func dispatch(f: Block) {
        if isExecutingOnMyQueue {
            f()
        } else {
            queue.sync(execute: f)
        }
    }

    public func dispatchWithReturn<T>(f: () -> T) -> T {
        var result: T!

        if isExecutingOnMyQueue {
            result = f()
        } else {
            queue.sync {
                result = f()
            }
        }

        return result!
    }

    public func dispatchOnMain(f: Block) {
        mainQueue.sync(execute: f)
    }

    public func dispatchOnMainWithReturn<T>(f: () -> T) -> T {
        var result: T!

        mainQueue.sync {
            result = f()
        }

        return result!
    }
}
