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
        get { return getAction(forName: .UIApplicationDidChangeStatusBarOrientation) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidChangeStatusBarOrientation) }
    }

    public var willChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(forName: .UIApplicationWillChangeStatusBarFrame) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillChangeStatusBarFrame) }
    }

    public var didChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(forName: .UIApplicationDidChangeStatusBarFrame) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidChangeStatusBarFrame) }
    }

    public var backgroundRefreshStatusDidChange: NotificationBlock? {
        get { return getAction(forName: .UIApplicationBackgroundRefreshStatusDidChange) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationBackgroundRefreshStatusDidChange) }
    }
}
