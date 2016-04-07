//
//  NotificationAction.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class NotificationActions {
    var notificationActions = [String: NotificationAction]()
    
    public init() {
    }
    
    func getAction(forName name: String) -> NotificationBlock? {
        return notificationActions[name]?.action
    }
    
    func setAction(action: NotificationBlock?, object: AnyObject?, name: String) {
        if let action = action {
            let notificationAction = NotificationAction(name: name, object: object, action: action)
            notificationActions[name] = notificationAction
        } else {
            removeAction(forName: name)
        }
    }
    
    func removeAction(forName name: String) {
        notificationActions.removeValueForKey(name)
    }
}
