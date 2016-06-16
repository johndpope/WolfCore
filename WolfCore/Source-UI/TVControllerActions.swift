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
        set { set(swipeAction: newValue, forDirection: .left, name: swipeLeftName) }
    }

    public var swipeRight: GestureBlock? {
        get { return getAction(forName: swipeRightName) }
        set { set(swipeAction: newValue, forDirection: .right, name: swipeRightName) }
    }

    public var swipeUp: GestureBlock? {
        get { return getAction(forName: swipeUpName) }
        set { set(swipeAction: newValue, forDirection: .up, name: swipeUpName) }
    }

    public var swipeDown: GestureBlock? {
        get { return getAction(forName: swipeDownName) }
        set { set(swipeAction: newValue, forDirection: .down, name: swipeDownName) }
    }

    public var pressLeft: GestureBlock? {
        get { return getAction(forName: pressLeftName) }
        set { set(pressAction: newValue, forPress: .leftArrow, name: pressLeftName) }
    }

    public var pressRight: GestureBlock? {
        get { return getAction(forName: pressRightName) }
        set { set(pressAction: newValue, forPress: .rightArrow, name: pressRightName) }
    }

    public var pressUp: GestureBlock? {
        get { return getAction(forName: pressUpName) }
        set { set(pressAction: newValue, forPress: .upArrow, name: pressLeftName) }
    }

    public var pressDown: GestureBlock? {
        get { return getAction(forName: pressDownName) }
        set { set(pressAction: newValue, forPress: .downArrow, name: pressDownName) }
    }

    public var pressPlayPause: GestureBlock? {
        get { return getAction(forName: pressPlayPauseName) }
        set { set(pressAction: newValue, forPress: .playPause, name: pressPlayPauseName) }
    }

    public var pressSelect: GestureBlock? {
        get { return getAction(forName: pressSelectName) }
        set { set(pressAction: newValue, forPress: .select, name: pressSelectName) }
    }

    public var pressMenu: GestureBlock? {
        get { return getAction(forName: pressMenuName) }
        set { set(pressAction: newValue, forPress: .menu, name: pressMenuName) }
    }
}
