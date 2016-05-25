//
//  OrientationNotificationActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class OrientationNotificationActions: NotificationActions {
    public var didChangeStatusBarOrientation: NotificationBlock? {
        get { return getAction(forName: UIApplicationDidChangeStatusBarOrientationNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationDidChangeStatusBarOrientationNotification) }
    }

    public var willChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(forName: UIApplicationWillChangeStatusBarFrameNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationWillChangeStatusBarFrameNotification) }
    }

    public var didChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(forName: UIApplicationDidChangeStatusBarFrameNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationDidChangeStatusBarFrameNotification) }
    }

    public var backgroundRefreshStatusDidChange: NotificationBlock? {
        get { return getAction(forName: UIApplicationBackgroundRefreshStatusDidChangeNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationBackgroundRefreshStatusDidChangeNotification) }
    }
}
