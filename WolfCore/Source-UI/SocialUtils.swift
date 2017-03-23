//
//  SocialUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public struct Social {
    public enum Error: Swift.Error {
        case badID(String?)
        case missingScheme
        case disallowedScheme(String)
    }

    private static func newURL(with template: String, userID: String?) throws -> URL {
        let string: String
        if let userID = userID {
            string = template.replacingPlaceholders(withReplacements: ["userID": userID])
        } else {
            string = template
        }
        guard let url = URL(string: string) else {
            throw Error.badID(userID)
        }
        guard let scheme = url.scheme else {
            throw Error.missingScheme
        }
        let registeredSchemes: [String] = appInfo["LSApplicationQueriesSchemes"] as? [String] ?? []
        let allowedSchemes = registeredSchemes + ["https"]
        guard allowedSchemes.contains(scheme) else {
            throw Error.disallowedScheme(scheme)
        }
        return url
    }

    /// The scheme in `appTemplate` must be registered in the `LSApplicationQueriesSchemes` array in the app's Info.plist.
    /// The scheme in `browserTemplate` should be "https" or else the URL will also need to be registered in `NSAppTransportSecurity` in Info.plist.
    fileprivate static func openURL(appTemplate: String?, browserTemplate: String, userID: String?) throws {
        if let appTemplate = appTemplate {
            let appURL = try newURL(with: appTemplate, userID: userID)
            guard !UIApplication.shared.canOpenURL(appURL) else {
                UIApplication.shared.openURL(appURL)
                return
            }
        }
        let browserURL = try newURL(with: browserTemplate, userID: userID)
        UIApplication.shared.openURL(browserURL)
    }
}

extension StringValidation {
    fileprivate func beginsWithLetter() throws -> StringValidation {
        do {
            return try pattern("^[a-zA-Z]")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must begin with a letter.", violation: "beginsWithLetter")
        }
    }

    fileprivate func beginsWithLetterOrNumber() throws -> StringValidation {
        do {
            return try pattern("^[a-zA-Z0-9]")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must begin with a letter or number.", violation: "beginsWithLetterOrNumber")
        }
    }

    fileprivate func endsWithLetterOrNumber() throws -> StringValidation {
        do {
            return try pattern("[a-zA-Z0-9]$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} must end with a letter or number.", violation: "endsWithLetterOrNumber")
        }
    }

    fileprivate func containsOnlyValidSnapchatCharacters() throws -> StringValidation {
        do {
            return try pattern("^[a-zA-Z0-9_.\\-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidSnapchatCharacters")
        }
    }

    fileprivate func containsOnlyValidInstagramCharacters() throws -> StringValidation {
        do {
            return try pattern("^[_.a-zA-Z0-9]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidInstagramCharacters")
        }
    }

    fileprivate func containsOnlyValidFacebookCharacters() throws -> StringValidation {
        do {
            return try pattern("^[.a-zA-Z0-9]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidFacebookCharacters")
        }
    }
}

public struct Facebook {
    public static func open(userID: String? = nil) throws {
        if let userID = userID {
            // Facebook DOES NOT support a way to link into the native iOS app. The schema "fb://profile/#{userID}" does not work, nor does app-scoped IDs. See https://developers.facebook.com/bugs/332195860270199
            try Social.openURL(appTemplate: nil, browserTemplate: "https://www.facebook.com/#{userID}", userID: userID)
        } else {
            try Social.openURL(appTemplate: nil, browserTemplate: "https://www.facebook.com/", userID: userID)
        }
    }

    private static let minLength = 5
    private static let maxLength = 50

    public static func editValidator(userID: String?, name: String = "Facebook") -> String? {
        return try? StringValidation(value: userID, name: name).maxLength(maxLength).containsOnlyValidFacebookCharacters().value
    }

    public static func validate(userID: String, name: String = "Snapchat") throws -> String {
        return try StringValidation(value: userID, name: name).minLength(minLength).maxLength(maxLength).beginsWithLetterOrNumber().endsWithLetterOrNumber().containsOnlyValidFacebookCharacters().value
    }
}

public struct Instagram {
    public static func open(userID: String? = nil) throws {
        if let userID = userID {
            try Social.openURL(appTemplate: "instagram://user?username=#{userID}", browserTemplate: "https://instagram.com/#{userID}", userID: userID)
        } else {
            try Social.openURL(appTemplate: "instagram://", browserTemplate: "https://instagram.com/", userID: userID)
        }
    }

    private static let minLength = 1
    private static let maxLength = 15

    public static func editValidator(userID: String?, name: String = "Instagram") -> String? {
        return try? StringValidation(value: userID, name: name).lowercased().maxLength(maxLength).containsOnlyValidSnapchatCharacters().value
    }

    public static func validate(userID: String, name: String = "Snapchat") throws -> String {
        return try StringValidation(value: userID, name: name).lowercased().minLength(minLength).maxLength(maxLength).beginsWithLetter().endsWithLetterOrNumber().containsOnlyValidSnapchatCharacters().value
    }
}

public struct Snapchat {
    public static func open(userID: String? = nil) throws {
        if let userID = userID {
            try Social.openURL(appTemplate: "snapchat://add/#{userID}", browserTemplate: "https://www.snapchat.com/add/#{userID}", userID: userID)
        } else {
            try Social.openURL(appTemplate: "snapchat://", browserTemplate: "https://www.snapchat.com/", userID: userID)
        }
    }

    private static let minLength = 3
    private static let maxLength = 15

    public static func editValidator(userID: String?, name: String = "Snapchat") -> String? {
        return try? StringValidation(value: userID, name: name).lowercased().maxLength(maxLength).containsOnlyValidSnapchatCharacters().value
    }

    public static func validate(userID: String, name: String = "Snapchat") throws -> String {
        return try StringValidation(value: userID, name: name).lowercased().minLength(minLength).maxLength(maxLength).beginsWithLetter().endsWithLetterOrNumber().containsOnlyValidSnapchatCharacters().value
    }
}
