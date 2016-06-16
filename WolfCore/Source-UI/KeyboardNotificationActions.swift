//
//  KeyboardNotificationActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class KeyboardNotificationActions: NotificationActions {
    public var willShow: NotificationBlock? {
        get { return getAction(forName: .UIKeyboardWillShow) }
        set { setAction(using: newValue, object: nil, name: .UIKeyboardWillShow) }
    }

    public var didShow: NotificationBlock? {
        get { return getAction(forName: .UIKeyboardDidShow) }
        set { setAction(using: newValue, object: nil, name: .UIKeyboardDidShow) }
    }

    public var willHide: NotificationBlock? {
        get { return getAction(forName: .UIKeyboardWillHide) }
        set { setAction(using: newValue, object: nil, name: .UIKeyboardWillHide) }
    }

    public var didHide: NotificationBlock? {
        get { return getAction(forName: .UIKeyboardDidHide) }
        set { setAction(using: newValue, object: nil, name: .UIKeyboardDidHide) }
    }
}
