//
//  MessageBulletin.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#endif

open class MessageBulletin: Bulletin {
    public let title: String?
    public let message: String?

    public init(title: String? = nil, message: String? = nil, priority: Int = normalPriority, duration: TimeInterval? = nil) {
        self.title = title
        self.message = message
        super.init(priority: priority, duration: duration)
    }

    #if os(iOS)
    open override func newBulletinView() -> BulletinView {
        let view = MessageBulletinView(bulletin: self)
        return BulletinView(bulletin: self, view: view)
    }
    #endif
}
