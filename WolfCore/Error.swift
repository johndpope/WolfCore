//
//  Error.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

public protocol Error: ErrorType, CustomStringConvertible {
    var message: String { get }
}
