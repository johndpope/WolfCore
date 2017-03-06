//
//  NotificationAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class NotificationActions {
    var notificationActions = Dictionary<NSNotification.Name, NotificationAction>()

    public init() {
    }

    func getAction(for name: NSNotification.Name) -> NotificationBlock? {
        return notificationActions[name]?.notificationBlock
    }

    func setAction(using block: NotificationBlock?, object: AnyObject?, name: NSNotification.Name) {
        if let block = block {
            let notificationAction = NotificationAction(name: name, object: object, using: block)
            notificationActions[name] = notificationAction
        } else {
            removeAction(for: name)
        }
    }

    func removeAction(for name: NSNotification.Name) {
        notificationActions.removeValue(forKey: name)
    }
}
