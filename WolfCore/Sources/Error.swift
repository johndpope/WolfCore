//
//  Error.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

/// Classes that represent errors may conform to this protocol.
public protocol Error: ErrorType, CustomStringConvertible {
    /// A human-readable error message.
    var message: String { get }

    /// A numeric code for the error.
    var code: Int { get }

    /// A non-user-facing identifier used for automated UI testing
    var identifier: String { get }
}

// Conforms NSError to the Error protocol.
extension NSError: Error {
    public var message: String {
        return localizedDescription
    }

    public var identifier: String {
        return "NSError(\(code))"
    }
}
