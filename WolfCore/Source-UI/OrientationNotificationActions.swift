//
//  OrientationNotificationActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class OrientationNotificationActions: NotificationActions {
    public var didChangeStatusBarOrientation: NotificationBlock? {
        get { return getAction(for: .UIApplicationDidChangeStatusBarOrientation) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidChangeStatusBarOrientation) }
    }

    public var willChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(for: .UIApplicationWillChangeStatusBarFrame) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillChangeStatusBarFrame) }
    }

    public var didChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(for: .UIApplicationDidChangeStatusBarFrame) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidChangeStatusBarFrame) }
    }

    public var backgroundRefreshStatusDidChange: NotificationBlock? {
        get { return getAction(for: .UIApplicationBackgroundRefreshStatusDidChange) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationBackgroundRefreshStatusDidChange) }
    }
}
