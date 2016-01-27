//
//  Unimplemented.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

public struct Unimplemented: Error {
    public var message: String

    public init(message: String = "") {
        self.message = message
    }
}

extension Unimplemented: CustomStringConvertible {
    public var description: String {
        return "Unimplemented(\(message))"
    }
}
