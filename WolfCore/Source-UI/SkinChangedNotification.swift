//
//  SkinChangedNotification.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public let skinChangedNotification = NSNotification.Name("skinChangedNotification")

public func postSkinChangedNotification() {
    logInfo("skinChangedNotification sent", group: .skin)
    notificationCenter.post(name: skinChangedNotification)
}
