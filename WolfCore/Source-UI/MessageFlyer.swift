//
//  MessageFlyer.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/25/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class MessageFlyer: Flyer {
    public let title: String?
    public let message: String?
    public let textColor: UIColor
    public let backgroundColor: UIColor

    public init(title: String? = nil, message: String? = nil, textColor: UIColor = .black, backgroundColor: UIColor = .gray, priority: Int = 500, duration: TimeInterval? = nil) {
        self.title = title
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        super.init(priority: priority, duration: duration)
    }
}
