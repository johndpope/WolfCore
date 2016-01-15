//
//  GeneralError.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

public struct GeneralError: Error {
    public var message: String
    
    public init(message: String) {
        self.message = message
    }
}

extension GeneralError: CustomStringConvertible {
    public var description: String {
        return "GeneralError(\(message))"
    }
}
