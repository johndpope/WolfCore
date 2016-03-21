//
//  ValidationError.swift
//  WolfCore
//
//  Created by Robert McNally on 2/2/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public struct ValidationError: Error {
    public let message: String
    public let code: Int
    
    public init(message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }
}

extension ValidationError: CustomStringConvertible {
    public var description: String {
        return "ValidationError(\(message))"
    }
}
