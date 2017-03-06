//
//  Hysteresis.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/15/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

/**

 hys·ter·e·sis
 ˌhistəˈrēsis/
 noun
 Physics

 noun: hysteresis
 the phenomenon in which the value of a physical property lags behind changes in the effect causing it, as for instance when magnetic induction lags behind the magnetizing force.

 **/

public class Hysteresis {
    private let effectStartLag: TimeInterval
    private let effectEndLag: TimeInterval
    private let onEffectStart: Block
    private let onEffectEnd: Block
    private var effectStartCanceler: Cancelable?
    private var effectEndCanceler: Cancelable?
    private var isEffectStarted: Bool = false

    private lazy var locker: Locker = {
        return Locker(
            onLocked: { [unowned self] in self.startEffectLagged() },
            onUnlocked: { [unowned self] in self.endEffectLagged() }
        )
    }()

    /// It is *not* guaranteed that `onEffectStart` and `onEffectEnd` will be called on the main queue.
    public init(onEffectStart: @escaping Block, onEffectEnd: @escaping Block, effectStartLag: TimeInterval, effectEndLag: TimeInterval) {
        self.onEffectStart = onEffectStart
        self.onEffectEnd = onEffectEnd
        self.effectStartLag = effectStartLag
        self.effectEndLag = effectEndLag
    }

    public func newCause() -> Locker.Ref {
        return locker.newRef()
    }

    private func startEffectLagged() {
        effectEndCanceler?.cancel()
        effectStartCanceler = dispatchOnBackground(afterDelay: effectStartLag) {
            if !self.isEffectStarted {
                self.onEffectStart()
                self.isEffectStarted = true
            }
        }
    }

    private func endEffectLagged() {
        effectStartCanceler?.cancel()
        effectEndCanceler = dispatchOnBackground(afterDelay: self.effectEndLag) {
            if self.isEffectStarted {
                self.onEffectEnd()
                self.isEffectStarted = false
            }
        }
    }

    public func startCause() {
        locker.lock()
    }

    public func endCause() {
        locker.unlock()
    }
}
