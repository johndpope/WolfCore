//
//  NotificationCenterExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/16/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public let notificationCenter = NotificationCenter.default
public typealias NotificationObserver = NSObjectProtocol
public typealias NotificationBlock = (Notification) -> Void

extension NotificationCenter {
    public func post(name: NSNotification.Name) {
        post(name: name, object: nil)
    }

    public func addObserver(forName name: NSNotification.Name, object: AnyObject? = nil, using block: @escaping NotificationBlock) -> NotificationObserver {
        return self.addObserver(forName: name, object: object, queue: nil, using: block)
    }
}
