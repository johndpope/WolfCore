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

    public var onSwipeLeft: GestureBlock? {
        get { return getAction(for: swipeLeftName) }
        set { set(swipeAction: newValue, forDirection: .left, name: swipeLeftName) }
    }

    public var onSwipeRight: GestureBlock? {
        get { return getAction(for: swipeRightName) }
        set { set(swipeAction: newValue, forDirection: .right, name: swipeRightName) }
    }

    public var onSwipeUp: GestureBlock? {
        get { return getAction(for: swipeUpName) }
        set { set(swipeAction: newValue, forDirection: .up, name: swipeUpName) }
    }

    public var onSwipeDown: GestureBlock? {
        get { return getAction(for: swipeDownName) }
        set { set(swipeAction: newValue, forDirection: .down, name: swipeDownName) }
    }

    public var onPressLeft: GestureBlock? {
        get { return getAction(for: pressLeftName) }
        set { set(pressAction: newValue, forPress: .leftArrow, name: pressLeftName) }
    }

    public var onPressRight: GestureBlock? {
        get { return getAction(for: pressRightName) }
        set { set(pressAction: newValue, forPress: .rightArrow, name: pressRightName) }
    }

    public var onPressUp: GestureBlock? {
        get { return getAction(for: pressUpName) }
        set { set(pressAction: newValue, forPress: .upArrow, name: pressLeftName) }
    }

    public var onPressDown: GestureBlock? {
        get { return getAction(for: pressDownName) }
        set { set(pressAction: newValue, forPress: .downArrow, name: pressDownName) }
    }

    public var onPressPlayPause: GestureBlock? {
        get { return getAction(for: pressPlayPauseName) }
        set { set(pressAction: newValue, forPress: .playPause, name: pressPlayPauseName) }
    }

    public var onPressSelect: GestureBlock? {
        get { return getAction(for: pressSelectName) }
        set { set(pressAction: newValue, forPress: .select, name: pressSelectName) }
    }

    public var onPressMenu: GestureBlock? {
        get { return getAction(for: pressMenuName) }
        set { set(pressAction: newValue, forPress: .menu, name: pressMenuName) }
    }
}
