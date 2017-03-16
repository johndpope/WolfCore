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
        let registeredSchemes: [String] = infoDict["LSApplicationQueriesSchemes"] as? [String] ?? []
        let allowedSchemes = registeredSchemes + ["https"]
        guard allowedSchemes.contains(scheme) else {
            throw Error.disallowedScheme(scheme)
        }
        return url
    }

    /// The scheme in `appTemplate` must be registered in the `LSApplicationQueriesSchemes` array in the app's Info.plist.
    /// The scheme in `browserTemplate` should be "https" or else the URL will also need to be registered in `NSAppTransportSecurity` in Info.plist.
    private static func openSocialURL(appTemplate: String?, browserTemplate: String, userID: String?) throws {
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

    public static func openFacebook(user userID: String? = nil) throws {
        if let userID = userID {
            // Facebook DOES NOT support a way to link into the native iOS app. The schema "fb://profile/#{userID}" does not work, nor does app-scoped IDs. See https://developers.facebook.com/bugs/332195860270199
            try openSocialURL(appTemplate: nil, browserTemplate: "https://www.facebook.com/#{userID}", userID: userID)
        } else {
            try openSocialURL(appTemplate: nil, browserTemplate: "https://www.facebook.com/", userID: userID)
        }
    }

    public static func openInstagram(user userID: String? = nil) throws {
        if let userID = userID {
            try openSocialURL(appTemplate: "instagram://user?username=#{userID}", browserTemplate: "https://instagram.com/#{userID}", userID: userID)
        } else {
            try openSocialURL(appTemplate: "instagram://", browserTemplate: "https://instagram.com/", userID: userID)
        }
    }

    public static func openSnapchat(user userID: String? = nil) throws {
        if let userID = userID {
            try openSocialURL(appTemplate: "snapchat://add/#{userID}", browserTemplate: "https://www.snapchat.com/add/#{userID}", userID: userID)
        } else {
            try openSocialURL(appTemplate: "snapchat://", browserTemplate: "https://www.snapchat.com/", userID: userID)
        }
    }
}
