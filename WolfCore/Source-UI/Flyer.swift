//
//  Flyer.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/25/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class Flyer {
    public let uuid: UUID
    public let date: Date
    public let priority: Int
    public let duration: TimeInterval?

    public init(priority: Int, duration: TimeInterval?) {
        self.uuid = UUID()
        self.date = Date()
        self.priority = priority
        self.duration = duration
    }
}
