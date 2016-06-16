//
//  AnimationUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/20/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public let defaultAnimationDuration: TimeInterval = 0.4

public func dispatchAnimated(_ animated: Bool = true, duration: TimeInterval = defaultAnimationDuration, delay: TimeInterval = 0.0, options: UIViewAnimationOptions = [], animations: Block) {
    if animated {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: nil)
    } else {
        animations()
    }
}

public func dispatchAnimated(_ animated: Bool = true, duration: TimeInterval = defaultAnimationDuration, delay: TimeInterval = 0.0, options: UIViewAnimationOptions = [], animations: Block, completion: ((Bool) -> Void)) {
    if animated {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
    } else {
        animations()
        completion(true)
    }
}
