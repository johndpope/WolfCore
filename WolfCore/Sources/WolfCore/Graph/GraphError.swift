//
//  GraphError.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public struct GraphError: ExtensibleEnumeratedName, Error {
    public let name: String

    public init(_ name: String) { self.name = name}

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}
