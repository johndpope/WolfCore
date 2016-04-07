//
//  NotificationCenterExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/16/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public let notificationCenter = NSNotificationCenter.defaultCenter()
public typealias NotificationObserver = NSObjectProtocol
public typealias NotificationBlock = (NSNotification) -> Void

extension NSNotificationCenter {
    public func post(name: String) {
        self.postNotificationName(name, object: nil)
    }
    
    public func addObserver(name: String, object: AnyObject? = nil, action: NotificationBlock) -> NotificationObserver {
        return self.addObserverForName(name, object: object, queue: nil, usingBlock: action)
    }
}
