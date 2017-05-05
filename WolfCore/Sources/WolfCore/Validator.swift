//
//  Validator.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/18/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

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

    public func trimmed() -> StringValidation {
        return StringValidation(value: value.trimmingCharacters(in: .whitespacesAndNewlines), name: name)
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

    public func beginsWithLetter() throws -> StringValidation {
        do {
            return try pattern("^[a-zA-Z]")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must begin with a letter.", violation: "beginsWithLetter")
        }
    }

    public func beginsWithLetterOrNumber() throws -> StringValidation {
        do {
            return try pattern("^[a-zA-Z0-9]")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must begin with a letter or number.", violation: "beginsWithLetterOrNumber")
        }
    }

    public func endsWithLetterOrNumber() throws -> StringValidation {
        do {
            return try pattern("[a-zA-Z0-9]$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must end with a letter or number.", violation: "endsWithLetterOrNumber")
        }
    }

    public func containsDigit() throws -> StringValidation {
        do {
            return try pattern("[0-9]")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must contain a digit.", violation: "containsDigit")
        }
    }

    func matchesDataDetector(type: TextCheckingResult.CheckingType, scheme: String? = nil) -> Bool {
        let dataDetector = try! NSDataDetector(types: type.rawValue)
        let length = (value as NSString).length
        let range = NSRange(location: 0, length: length)
        guard let firstMatch = dataDetector.firstMatch(in: value, options: .reportCompletion, range: range) else {
            return false
        }
        return
            // make sure the entire string is an email, not just contains an email
            firstMatch.range == range
            // make sure the link type matches if link scheme
            && (type != .link || scheme == nil || firstMatch.url?.scheme == scheme)
    }

    public func email() throws -> StringValidation {
        guard matchesDataDetector(type: .link, scheme: "mailto") else {
            throw ValidationError(message: "#{name} must be a valid email address.", violation: "emailAddress")
        }
        return self
    }

    public func phoneNumber() throws -> StringValidation {
        guard matchesDataDetector(type: .phoneNumber) else {
            throw ValidationError(message: "#{name} must be a valid phone number.", violation: "emailAddress")
        }
        return self
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidEmailCharacters() throws -> StringValidation {
        do {
            return try pattern("^[_+.a-zA-Z0-9@-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidEmailCharacters")
        }
    }

    fileprivate func containsOnlyValidPhoneNumberCharacters() throws -> StringValidation {
        do {
            return try pattern("^[() +._0-9-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidPhoneNumberCharacters")
        }
    }
}

public struct Email {
    public static func editValidator(_ value: String?, name: String = "Email") -> String? {
        return try? StringValidation(value: value, name: name).trimmed().containsOnlyValidEmailCharacters().value
    }

    public static func validate(_ value: String, name: String = "Email") throws -> String {
        return try StringValidation(value: value, name: name).email().value
    }
}

public struct PhoneNumber {
    public static func editValidator(_ value: String?, name: String = "Phone Number") -> String? {
        return try? StringValidation(value: value, name: name).trimmed().containsOnlyValidPhoneNumberCharacters().value
    }

    public static func validate(_ value: String, name: String = "Phone Number") throws -> String {
        return try StringValidation(value: value, name: name).phoneNumber().value
    }
}

public struct Password {
    public static func editValidator(_ value: String?, name: String = "Password") -> String? {
        return try? StringValidation(value: value, name: name).maxLength(24).value
    }

    public static func validate(_ value: String, name: String = "Password") throws -> String {
        return try StringValidation(value: value, name: name).minLength(4).maxLength(24).containsDigit().value
    }
}
