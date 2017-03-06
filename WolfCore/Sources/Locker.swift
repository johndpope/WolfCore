//
//  Locker.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/17/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

public class Locker {
    private var count = 0
    private var serializer: Serializer!
    private lazy var reasonRefs: [String: Ref] = {
        return [String: Ref]()
    }()

    public var onLocked: Block?
    public var onUnlocked: Block?
    public typealias ChangedBlock = (Locker) -> Void
    public var onChanged: ChangedBlock?
    public var onReasonsChanged: ChangedBlock?

    /// It is *not* guaranteed that any of the callbacks will be called on the main queue.
    public init(onLocked: Block? = nil, onUnlocked: Block? = nil, onChanged: ChangedBlock? = nil, onReasonsChanged: ChangedBlock? = nil) {
        self.onLocked = onLocked
        self.onUnlocked = onUnlocked
        self.onChanged = onChanged
        self.onReasonsChanged = onReasonsChanged
        serializer = Serializer(label: "\(self)")
    }

    public var isLocked: Bool {
        return count > 0
    }

    public class Ref {
        private weak var tracker: Locker?

        init(tracker: Locker) {
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

    public var reasons: [String] {
        return Array(reasonRefs.keys)
    }

    public subscript(reason: String) -> Bool {
        get {
            return reasonRefs[reason] != nil
        }

        set {
            if newValue {
                guard reasonRefs[reason] == nil else { return }
                reasonRefs[reason] = newRef()
                onReasonsChanged?(self)
            } else {
                guard reasonRefs.removeValue(forKey: reason) != nil else { return }
                onReasonsChanged?(self)
            }
        }
    }

    private func _lock() {
        count = count + 1
        if count == 1 {
            onLocked?()
        }
        onChanged?(self)
    }

    private func _unlock() {
        assert(count > 0)
        count = count - 1
        if count == 0 {
            onUnlocked?()
        }
        onChanged?(self)
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
