//
//  AnimationUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/20/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public let defaultAnimationDuration: NSTimeInterval = 0.4

public func dispatchAnimated(animated: Bool = true, duration: NSTimeInterval = defaultAnimationDuration, delay: NSTimeInterval = 0.0, options: UIViewAnimationOptions = [], animations: DispatchBlock) {
    if animated {
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: nil)
    } else {
        animations()
    }
}

public func dispatchAnimated(animated: Bool = true, duration: NSTimeInterval = defaultAnimationDuration, delay: NSTimeInterval = 0.0, options: UIViewAnimationOptions = [], animations: DispatchBlock, completion: ((Bool) -> Void)) {
    if animated {
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
    } else {
        animations()
        completion(true)
    }
}
