//
//  ValidationError.swift
//  WolfCore
//
//  Created by Robert McNally on 2/2/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public struct ValidationError: Error {
    public var message: String
    
    public init(message: String) {
        self.message = message
    }
}

extension ValidationError: CustomStringConvertible {
    public var description: String {
        return "ValidationError(\(message))"
    }
}
