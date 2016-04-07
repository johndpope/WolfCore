//
//  KeyboardNotificationActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class KeyboardNotificationActions : NotificationActions {
    public var willShow: NotificationBlock? {
        get { return getAction(forName: UIKeyboardWillShowNotification) }
        set { setAction(newValue, object: nil, name: UIKeyboardWillShowNotification) }
    }
    
    public var didShow: NotificationBlock? {
        get { return getAction(forName: UIKeyboardDidShowNotification) }
        set { setAction(newValue, object: nil, name: UIKeyboardDidShowNotification) }
    }
    
    public var willHide: NotificationBlock? {
        get { return getAction(forName: UIApplicationWillEnterForegroundNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationWillEnterForegroundNotification) }
    }
    
    public var didHide: NotificationBlock? {
        get { return getAction(forName: UIKeyboardDidHideNotification) }
        set { setAction(newValue, object: nil, name: UIKeyboardDidHideNotification) }
    }
}
