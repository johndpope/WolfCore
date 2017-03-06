//
//  ApplicationNotificationActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class ApplicationNotificationActions: NotificationActions {
    public var didEnterBackground: NotificationBlock? {
        get { return getAction(for: .UIApplicationDidEnterBackground) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidEnterBackground) }
    }

    public var willEnterForeground: NotificationBlock? {
        get { return getAction(for: .UIApplicationWillEnterForeground) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillEnterForeground) }
    }

    public var didFinishLaunching: NotificationBlock? {
        get { return getAction(for: .UIApplicationDidFinishLaunching) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidFinishLaunching) }
    }

    public var didBecomeActive: NotificationBlock? {
        get { return getAction(for: .UIApplicationDidBecomeActive) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidBecomeActive) }
    }

    public var willResignActive: NotificationBlock? {
        get { return getAction(for: .UIApplicationWillResignActive) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillResignActive) }
    }

    public var didReceiveMemoryWarning: NotificationBlock? {
        get { return getAction(for: .UIApplicationDidReceiveMemoryWarning) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidReceiveMemoryWarning) }
    }

    public var willTerminate: NotificationBlock? {
        get { return getAction(for: .UIApplicationWillTerminate) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillTerminate) }
    }

    public var significantTimeChange: NotificationBlock? {
        get { return getAction(for: .UIApplicationSignificantTimeChange) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationSignificantTimeChange) }
    }
}
