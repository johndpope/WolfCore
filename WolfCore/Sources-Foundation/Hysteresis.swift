//
//  Hysteresis.swift
//  WolfCore
//
//  Created by Robert McNally on 12/15/15.
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
    private let effectStart: Block
    private let effectEnd: Block
    private var effectStartCanceler: Canceler?
    private var effectEndCanceler: Canceler?
    private var effectStarted: Bool = false

    private lazy var causeCount: ReferenceCounter = {
        return ReferenceCounter(
            onOneRef: { [unowned self] in self.onOneCause() },
            onZeroRefs: { [unowned self] in self.onZeroCauses() }
        )
    }()

    public init(effectStart: Block, effectEnd: Block, effectStartLag: TimeInterval, effectEndLag: TimeInterval) {
        self.effectStart = effectStart
        self.effectEnd = effectEnd
        self.effectStartLag = effectStartLag
        self.effectEndLag = effectEndLag
    }

    public func newCause() -> ReferenceCounter.Ref {
        return causeCount.newRef()
    }

    private func onOneCause() {
        effectEndCanceler?.cancel()
        effectStartCanceler = dispatchOnBackground(afterDelay: effectStartLag) {
            if !self.effectStarted {
                self.effectStart()
                self.effectStarted = true
            }
        }
    }

    private func onZeroCauses() {
        effectStartCanceler?.cancel()
        effectEndCanceler = dispatchOnBackground(afterDelay: self.effectEndLag) {
            if self.effectStarted {
                self.effectEnd()
                self.effectStarted = false
            }
        }
    }
}
