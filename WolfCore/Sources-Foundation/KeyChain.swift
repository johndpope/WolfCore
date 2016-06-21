//
//  KeyChain.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct KeyChain {

    public static func add(data: Data, forKey key: String, inAccount account: String) throws {
        let query: [NSString : AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrLabel : key,
            kSecAttrAccount : account,
            kSecValueData : data
        ]
        let result = SecItemAdd(query, nil)
        guard result == errSecSuccess else {
            throw GeneralError(message: "Could not add to keychain.", code: Int(result))
        }
    }

    public static func add(string: String, forKey key: String, inAccount account: String) throws {
        try add(data: string |> UTF8.encode, forKey: key, inAccount: account)
    }

    public static func delete(key: String, account: String) throws {
        let query: [NSString : AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrAccount : account,
            kSecReturnAttributes : true,
            kSecReturnData : true
        ]

        let result = SecItemDelete(query)
        guard result == errSecSuccess else {
            throw GeneralError(message: "Could not delete from keychain.", code: Int(result))
        }
    }

    public static func update(data: Data, forKey key: String, inAccount account: String, addIfNotFound: Bool = false) throws {
        let query: [NSString : AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : account,
            kSecAttrService : key,
            ]

        let queryNew: [NSString : AnyObject] = [
            kSecAttrAccount : account,
            kSecAttrService : key,
            kSecValueData : data
        ]

        let result = SecItemUpdate(query, queryNew)
        if result == errSecItemNotFound && addIfNotFound {
            try add(data: data, forKey: key, inAccount: account)
            return
        }

        guard result == errSecSuccess else {
            throw GeneralError(message: "Could not update keychain.", code: Int(result))
        }
    }

    public static func update(string: String, forKey key: String, inAccount account: String, addIfNotFound: Bool = false) throws {
        try update(data: string |> UTF8.encode, forKey: key, inAccount: account, addIfNotFound: addIfNotFound)
    }

    public static func update(number: NSNumber, forKey key: String, inAccount account: String, addIfNotFound: Bool = false) throws {
        try update(data: NSKeyedArchiver.archivedData(withRootObject: number), forKey: key, inAccount: account, addIfNotFound: addIfNotFound)
    }

    public static func update(bool: Bool, forKey key: String, inAccount account: String, addIfNotFound: Bool = false) throws {
        try update(number:(bool as NSNumber), forKey: key, inAccount: account, addIfNotFound: addIfNotFound)
    }

    public static func readData(forKey key: String, inAccount account: String) throws -> Data? {
        let query: [NSString : AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrAccount : account,
            kSecReturnAttributes : true,
            kSecReturnData : true
        ]

        var value: AnyObject?
        let result = SecItemCopyMatching(query, &value)
        guard result == errSecSuccess else {
            throw GeneralError(message: "Unable to read keychain.", code: Int(result))
        }
        guard let dict = value as? [NSString: AnyObject] else {
            throw GeneralError(message: "Key chain data wrong type.")
        }
        guard let data = dict[kSecValueData] as? Data else {
            return nil
        }
        return data
    }

    public static func readString(forKey key: String, inAccount account: String) throws -> String? {
        guard let data = try readData(forKey: key, inAccount: account) else {
            return nil
        }
        return try data |> UTF8.decode
    }

    public static func readNumber(forKey key: String, inAccount account: String) throws -> NSNumber? {
        guard let data = try readData(forKey: key, inAccount: account) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber
    }

    public static func readBool(forKey key: String, inAccount account: String) throws -> Bool? {
        return try readNumber(forKey: key, inAccount: account) as? Bool
    }
}
