//
//  Skin.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/3/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

extension Log.GroupName {
    public static let skin = Log.GroupName("skin")
}

public protocol Skin { }

public var skin: Skin! {
    didSet {
        postSkinChangedNotification()
    }
}
