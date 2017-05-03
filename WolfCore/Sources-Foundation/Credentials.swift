//
//  Credentials.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/3/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public protocol Credentials: JSONModel {
    static var name: String { get }
    var authorization: String { get }
    static func load() -> Self?
    func save()
    func delete()
}

extension Credentials {
    public func save() {
        try! KeyChain.update(json: json, for: Self.name)
    }

    public static func load() -> Self? {
        guard let json = try! KeyChain.json(for: Self.name) else { return nil }
        return Self(json: json)
    }

    public func delete() {
        try! KeyChain.delete(key: Self.name)
    }
}
