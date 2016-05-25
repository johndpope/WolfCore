//
//  TVControllerActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class TVControllerActions: GestureActions {
    private let swipeLeftName = "swipeLeft"
    private let swipeRightName = "swipeRight"
    private let swipeUpName = "swipeUp"
    private let swipeDownName = "swipeDown"
    private let pressLeftName = "pressLeft"
    private let pressRightName = "pressRight"
    private let pressUpName = "pressUp"
    private let pressDownName = "pressDown"
    private let pressPlayPauseName = "pressPlayPause"
    private let pressSelectName = "pressSelect"
    private let pressMenuName = "pressMenu"

    public var swipeLeft: GestureBlock? {
        get { return getAction(forName: swipeLeftName) }
        set { setSwipeAction(newValue, forDirection: .Left, name: swipeLeftName) }
    }

    public var swipeRight: GestureBlock? {
        get { return getAction(forName: swipeRightName) }
        set { setSwipeAction(newValue, forDirection: .Right, name: swipeRightName) }
    }

    public var swipeUp: GestureBlock? {
        get { return getAction(forName: swipeUpName) }
        set { setSwipeAction(newValue, forDirection: .Up, name: swipeUpName) }
    }

    public var swipeDown: GestureBlock? {
        get { return getAction(forName: swipeDownName) }
        set { setSwipeAction(newValue, forDirection: .Down, name: swipeDownName) }
    }

    public var pressLeft: GestureBlock? {
        get { return getAction(forName: pressLeftName) }
        set { setPressAction(newValue, forPress: .LeftArrow, name: pressLeftName) }
    }

    public var pressRight: GestureBlock? {
        get { return getAction(forName: pressRightName) }
        set { setPressAction(newValue, forPress: .RightArrow, name: pressRightName) }
    }

    public var pressUp: GestureBlock? {
        get { return getAction(forName: pressUpName) }
        set { setPressAction(newValue, forPress: .UpArrow, name: pressLeftName) }
    }

    public var pressDown: GestureBlock? {
        get { return getAction(forName: pressDownName) }
        set { setPressAction(newValue, forPress: .DownArrow, name: pressDownName) }
    }

    public var pressPlayPause: GestureBlock? {
        get { return getAction(forName: pressPlayPauseName) }
        set { setPressAction(newValue, forPress: .PlayPause, name: pressPlayPauseName) }
    }

    public var pressSelect: GestureBlock? {
        get { return getAction(forName: pressSelectName) }
        set { setPressAction(newValue, forPress: .Select, name: pressSelectName) }
    }

    public var pressMenu: GestureBlock? {
        get { return getAction(forName: pressMenuName) }
        set { setPressAction(newValue, forPress: .Menu, name: pressMenuName) }
    }
}
