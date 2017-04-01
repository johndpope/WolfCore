//
//  Credentials.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/3/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

private let credentialsKey = "credentials"

public protocol Credentials: JSONModel {
    func save() throws
    static func load() throws -> Self?
    static func delete() throws
}

extension Credentials {
    public func save() throws {
        try KeyChain.update(json: json, for: credentialsKey)
    }

    public static func load() throws -> Self? {
        guard let json = try KeyChain.json(for: credentialsKey) else { return nil }
        return Self(json: json)
    }

    public static func delete() throws {
        try KeyChain.delete(key: credentialsKey)
    }
}

/****

public struct Credentials: WolfCore.Credentials {
    public let email: String
    public let password: String
    public let authToken: String

    public init(email: String, password: String, authToken: String) {
        self.email = email
        self.password = password
        self.authToken = authToken
    }

    private let emailKey = "email"
    private let passwordKey = "password"
    private let authTokenKey = "authToken"

    public var json: JSON {
        let dict: JSON.Dictionary = [
            emailKey: email,
            passwordKey: password,
            authTokenKey: authToken
        ]
        return try! JSON(value: dict)
    }

    public init(json: JSON) throws {
        let dict = json.dictionary
        email = try JSON.string(for: emailKey, in: dict)
        password = try JSON.string(for: passwordKey, in: dict)
        authToken = try JSON.string(for: authTokenKey, in: dict)
    }
}

****/
