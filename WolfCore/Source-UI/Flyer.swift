//
//  Flyer.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public protocol Flyer: class {
    var priority: Int { get }
    var duration: TimeInterval? { get }
}
