//
//  GeneralError.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

/// Represents a non-specific error result.
public struct GeneralError: Error {
    /// A human-readable error message
    public var message: String

    /// A numeric code for the error
    public var code: Int

    public init(message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }
}

/// Provides string conversion for GeneralError.
extension GeneralError: CustomStringConvertible {
    public var description: String {
        return "GeneralError(\(message), code: \(code))"
    }
}
