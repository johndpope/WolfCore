//
//  KeyboardMovementAction.swift
//  WolfCore
//
//  Created by Robert McNally on 6/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public typealias KeyboardMovementBlock = (KeyboardMovement) -> Void

public class KeyboardMovementAction: NotificationAction {
    public let keyboardMovementBlock: KeyboardMovementBlock

    public init(name: NSNotification.Name, using keyboardMovementBlock: KeyboardMovementBlock) {
        self.keyboardMovementBlock = keyboardMovementBlock
        super.init(name: name) { notification in
            let info = KeyboardMovement(notification: notification)
            keyboardMovementBlock(info)
        }
    }
}
