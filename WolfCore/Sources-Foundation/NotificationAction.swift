//
//  NotificationAction.swift
//  WolfCore
//
//  Created by Robert McNally on 7/17/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

public class NotificationAction {
    private let observer: NotificationObserver
    public let block: NotificationBlock

    public init(name: NSNotification.Name, using block: @escaping NotificationBlock) {
        self.block = block
        observer = notificationCenter.addObserver(forName: name, using: block)
    }

    public init(name: NSNotification.Name, object: AnyObject?, using block: @escaping NotificationBlock) {
        self.block = block
        observer = notificationCenter.addObserver(forName: name, object: object, queue: nil, using: block)
    }

    deinit {
        notificationCenter.removeObserver(observer)
    }
}
