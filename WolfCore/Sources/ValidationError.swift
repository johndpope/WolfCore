//
//  ValidationError.swift
//  WolfCore
//
//  Created by Robert McNally on 2/2/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public struct ValidationError: Error {
    public var message: String
    private var aIdentifier: String
    public var fieldIdentifier: String?
    public var code: Int

    public init(message: String, identifier: String, fieldIdentifier: String? = nil, code: Int = 1) {
        self.message = message
        self.aIdentifier = identifier
        self.fieldIdentifier = fieldIdentifier
        self.code = code
    }

    public var identifier: String {
        if let fieldIdentifier = fieldIdentifier {
            return "\(fieldIdentifier)-\(aIdentifier)"
        } else {
            return "\(aIdentifier)"
        }
    }
}

extension ValidationError: CustomStringConvertible {
    public var description: String {
        return "ValidationError(\(message) [\(identifier)])"
    }
}
