//
//  NotificationUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/17/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public class NotificationAction {
    private let observer: NotificationObserver
    
    public init(name: String, action: DispatchBlock) {
        observer = notificationCenter.addObserver(name, action: action)
    }
    
    public init(name: String, object: AnyObject?, action: (NSNotification) -> Void) {
        observer = notificationCenter.addObserverForName(name, object: object, queue: nil, usingBlock: action)
    }
    
    deinit {
        notificationCenter.removeObserver(observer)
    }
}
