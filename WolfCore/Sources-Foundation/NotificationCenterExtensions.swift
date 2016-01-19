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

extension NSNotificationCenter {
    public func post(name: String) {
        self.postNotificationName(name, object: nil)
    }
    
    public func addObserver(name: String, action: DispatchBlock) -> NotificationObserver {
        return self.addObserverForName(name, object: nil, queue: nil) { _ in
            action()
        }
    }
}
