//
//  Validator.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/18/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public protocol Validation {
    associatedtype Value
    var value: Value { get }
    var name: String { get }
}

public struct StringValidation: Validation {
    public let value: String
    public let name: String

    public init(value: String?, name: String) {
        self.name = name
        self.value = value ?? ""
    }
}

extension StringValidation {
    public func minLength(_ minLength: Int?) throws -> StringValidation {
        guard let minLength = minLength else { return self }
        guard value.characters.count >= minLength else {
            throw ValidationError(message: "#{name} must be at least #{minLength} characters." ¶ ["name": name, "minLength": String(minLength)], violation: "minLength")
        }
        return self
    }

    public func maxLength(_ maxLength: Int?) throws -> StringValidation {
        guard let maxLength = maxLength else { return self }
        guard value.characters.count <= maxLength else {
            throw ValidationError(message: "#{name} may not be more than #{maxLength} characters." ¶ ["name": name, "maxLength": String(maxLength)], violation: "maxLength")
        }
        return self
    }

    public func lowercased() -> StringValidation {
        return StringValidation(value: value.lowercased(), name: name)
    }

    public func pattern(_ pattern: String) throws -> StringValidation {
        let regex = try! ~/pattern
        guard (regex ~? value) else {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "pattern")
        }
        return self
    }
}
