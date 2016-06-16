//
//  IPAddress4.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension Array {
    public static func ipAddress4(from ip4Bytes: Bytes) -> String {
        assert(ip4Bytes.count == 4)
        var components = [String]()
        for byte in ip4Bytes {
            components.append(String(byte))
        }
        return components.joined(separator: ".")
    }
}

extension Data {
    public static func ipAdress4(from ip4Data: Data) -> String {
        return ip4Data |> Data.bytes |> Bytes.ipAddress4
    }
}

public class IPAddress4 {
    public static func bytes(from ip4String: String) throws -> Bytes {
        let components = ip4String.components(separatedBy: ".")
        guard components.count == 4 else {
            throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
        }
        var bytes = Bytes()
        for component in components {
            guard let i = Int(component) else {
                throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
            }
            guard i >= 0 && i <= 255 else {
                throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
            }
            bytes.append(Byte(i))
        }
        return bytes
    }

    public static func data(from ip4String: String) throws -> Data {
        return try ip4String |> bytes |> Bytes.data
    }
}

extension IPAddress4 {
    public static func test() {
        do {
            let bytes: Bytes = [127, 0, 0, 1]
            let encoded = bytes |> Bytes.ipAddress4
            assert(encoded == "127.0.0.1")
            print(encoded)
            let decoded = try encoded |> IPAddress4.bytes
            assert(decoded == bytes)
            print(decoded)
        } catch let error {
            logError(error)
        }
    }
}
