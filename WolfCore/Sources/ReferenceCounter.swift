//
//  File.swift
//  WolfCore
//
//  Created by Robert McNally on 6/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class ReferenceCounter {
    public var onOneRef: Block?
    public var onZeroRefs: Block?

    public init(onOneRef: Block? = nil, onZeroRefs: Block? = nil) {
        self.onOneRef = onOneRef
        self.onZeroRefs = onZeroRefs
        serializer = Serializer(name: "\(self)")
    }

    private var count = 0
    private var serializer: Serializer!

    public var isActive: Bool {
        return count > 0
    }

    public class Ref {
        private weak var tracker: ReferenceCounter?

        private init(tracker: ReferenceCounter) {
            self.tracker = tracker
            tracker.increment()
        }

        deinit {
            tracker?.decrement()
        }
    }

    public func newRef() -> Ref {
        return Ref(tracker: self)
    }

    private func _increment() {
        count = count + 1
        if count == 1 {
            onOneRef?()
        }
    }

    private func _decrement() {
        assert(count > 0)
        count = count - 1
        if count == 0 {
            onZeroRefs?()
        }
    }

    public func increment() {
        serializer.dispatch {
            self._increment()
        }
    }

    public func decrement() {
        serializer.dispatch {
            self._decrement()
        }
    }
}
