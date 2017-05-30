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

public class MessageBulletin: Bulletin {
    public let title: String?
    public let message: String?
    public let textColor: Color
    public let backgroundColor: Color

    public init(title: String? = nil, message: String? = nil, textColor: Color = .black, backgroundColor: Color = .gray, priority: Int = 500, duration: TimeInterval? = nil) {
        self.title = title
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        super.init(priority: priority, duration: duration)
    }

    #if os(iOS)
    public override func newBulletinView() -> BulletinView {
        let view = MessageBulletinView(bulletin: self)
        return BulletinView(bulletin: self, view: view)
    }
    #endif
}
