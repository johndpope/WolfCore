//
//  ApplicationNotificationActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class ApplicationNotificationActions : NotificationActions {
    public var didEnterBackground: NotificationBlock? {
        get { return getAction(forName: UIApplicationDidEnterBackgroundNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationDidEnterBackgroundNotification) }
    }
    
    public var willEnterForeground: NotificationBlock? {
        get { return getAction(forName: UIApplicationWillEnterForegroundNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationWillEnterForegroundNotification) }
    }
    
    public var didFinishLaunching: NotificationBlock? {
        get { return getAction(forName: UIApplicationDidFinishLaunchingNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationDidFinishLaunchingNotification) }
    }
    
    public var didBecomeActive: NotificationBlock? {
        get { return getAction(forName: UIApplicationDidBecomeActiveNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationDidBecomeActiveNotification) }
    }
    
    public var willResignActive: NotificationBlock? {
        get { return getAction(forName: UIApplicationWillResignActiveNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationWillResignActiveNotification) }
    }
    
    public var didReceiveMemoryWarning: NotificationBlock? {
        get { return getAction(forName: UIApplicationDidReceiveMemoryWarningNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationDidReceiveMemoryWarningNotification) }
    }
    
    public var willTerminate: NotificationBlock? {
        get { return getAction(forName: UIApplicationWillTerminateNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationWillTerminateNotification) }
    }
    
    public var significantTimeChange: NotificationBlock? {
        get { return getAction(forName: UIApplicationSignificantTimeChangeNotification) }
        set { setAction(newValue, object: nil, name: UIApplicationSignificantTimeChangeNotification) }
    }
}
