//
//  Locker.swift
//  WolfCore
//
//  Created by Robert McNally on 6/17/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

public class Locker {
    private var count = 0
    private var serializer: Serializer!

    public var onLocked: Block?
    public var onUnlocked: Block?

    /// It is *not* guaranteed that `onLocked` and `onUnlocked` will be called on the main queue.
    public init(onLocked: Block? = nil, onUnlocked: Block? = nil) {
        self.onLocked = onLocked
        self.onUnlocked = onUnlocked
        serializer = Serializer(name: "\(self)")
    }

    public var isLocked: Bool {
        return count > 0
    }

    public class Ref {
        private weak var tracker: Locker?

        private init(tracker: Locker) {
            self.tracker = tracker
            tracker.lock()
        }

        deinit {
            tracker?.unlock()
        }
    }

    public func newRef() -> Ref {
        return Ref(tracker: self)
    }

    private func _lock() {
        count = count + 1
        if count == 1 {
            onLocked?()
        }
    }

    private func _unlock() {
        assert(count > 0)
        count = count - 1
        if count == 0 {
            onUnlocked?()
        }
    }

    public func lock() {
        serializer.dispatch {
            self._lock()
        }
    }

    public func unlock() {
        serializer.dispatch {
            self._unlock()
        }
    }
}
