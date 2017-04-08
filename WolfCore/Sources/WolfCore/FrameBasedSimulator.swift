//
//  FrameBasedSimulator.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public protocol FrameBasedSystem {
    func simulate(forUpTo maxDuration: TimeInterval) -> (actualDuration: TimeInterval, timeBeforeTransition: TimeInterval)
    func transition() -> Bool
}

open class FrameBasedSimulator {
    public var system: FrameBasedSystem?
    public var isPaused: Bool = false {
        didSet {
            if isPaused == true {
                myTime = nil
            }
        }
    }

    public init(system: FrameBasedSystem? = nil) {
        self.system = system
    }

    private var myTime: TimeInterval!

    public func update(to currentTime: TimeInterval) {
        guard let system = system else { return }
        guard !isPaused else { return }

        if myTime == nil {
            myTime = currentTime
            _ = system.transition()
        }

        let elapsedTime = currentTime - myTime

        var remainingTime = elapsedTime
        while myTime < currentTime {
            let (actualDuration, timeBeforeTransition) = system.simulate(forUpTo: remainingTime)
            if timeBeforeTransition <= 0.0 {
                let done = system.transition()
                if done {
                    isPaused = true
                    break
                }
            }
            remainingTime -= actualDuration
            myTime = myTime + actualDuration
        }
    }

    public func invalidate() {
        system = nil
    }
}
