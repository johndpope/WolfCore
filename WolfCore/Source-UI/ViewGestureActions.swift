//
//  ViewGestureActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class ViewGestureActions: GestureActions {
    private let tapName = "tap"

    public var tap: GestureBlock? {
        get { return getAction(forName: tapName) }
        set { setTapAction(newValue, name: tapName) }
    }
}
