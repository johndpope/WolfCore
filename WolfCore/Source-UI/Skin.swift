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

public let skinChangedNotification = NSNotification.Name("skinChangedNotification")

public protocol Skin { }

public var skin: Skin! {
    didSet {
        postSkinChangedNotification()
    }
}

public class SkinChangedAction {
    var notificationAction: NotificationAction!
    weak var obj: AnyObject?

    public init(for obj: AnyObject, action: @escaping Block) {
        self.obj = obj
        notificationAction = NotificationAction(name: skinChangedNotification) { _ in
            if let obj = self.obj {
                logTrace("skinChangedNotification received by \(obj)", group: .skin)
                action()
            }
        }
    }

    deinit {
        notificationAction = nil
    }
}

public func postSkinChangedNotification() {
    logInfo("skinChangedNotification sent", group: .skin)
    notificationCenter.post(name: skinChangedNotification)
}
