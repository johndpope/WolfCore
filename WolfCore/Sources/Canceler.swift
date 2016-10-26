//
//  Canceler.swift
//  WolfCore
//
//  Created by Robert McNally on 6/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

// A Canceler is returned by functions in this file that either execute a block after a delay, or execute a block at intervals. If the <isCanceled> variable is set to true, the block will never be executed, or the calling of the block at intervals will stop.
public class Canceler {
    public var isCanceled = false
    public init() { }
    public func cancel() { isCanceled = true }
}

// A block that takes a Canceler. The block will not be called again if it sets the <isCanceled> variable of the Canceler to true.
public typealias CancelableBlock = (_ canceler: Canceler) -> Void
