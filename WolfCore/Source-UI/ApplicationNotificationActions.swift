//
//  ApplicationNotificationActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class ApplicationNotificationActions: NotificationActions {
    public var didEnterBackground: NotificationBlock? {
        get { return getAction(forName: .UIApplicationDidEnterBackground) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidEnterBackground) }
    }

    public var willEnterForeground: NotificationBlock? {
        get { return getAction(forName: .UIApplicationWillEnterForeground) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillEnterForeground) }
    }

    public var didFinishLaunching: NotificationBlock? {
        get { return getAction(forName: .UIApplicationDidFinishLaunching) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidFinishLaunching) }
    }

    public var didBecomeActive: NotificationBlock? {
        get { return getAction(forName: .UIApplicationDidBecomeActive) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidBecomeActive) }
    }

    public var willResignActive: NotificationBlock? {
        get { return getAction(forName: .UIApplicationWillResignActive) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillResignActive) }
    }

    public var didReceiveMemoryWarning: NotificationBlock? {
        get { return getAction(forName: .UIApplicationDidReceiveMemoryWarning) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationDidReceiveMemoryWarning) }
    }

    public var willTerminate: NotificationBlock? {
        get { return getAction(forName: .UIApplicationWillTerminate) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationWillTerminate) }
    }

    public var significantTimeChange: NotificationBlock? {
        get { return getAction(forName: .UIApplicationSignificantTimeChange) }
        set { setAction(using: newValue, object: nil, name: .UIApplicationSignificantTimeChange) }
    }
}
