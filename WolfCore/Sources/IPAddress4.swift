//
//  IPAddress4.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class IPAddress4 {
    public static func encode(bytes: Bytes) -> String {
        assert(bytes.count == 4)
        var components = [String]()
        for byte in bytes {
            components.append(String(byte))
        }
        return components.joinWithSeparator(".")
    }

    public static func decode(string: String) throws -> Bytes {
        let components = string.componentsSeparatedByString(".")
        guard components.count == 4 else {
            throw ValidationError(message: "Invalid IP address.", identifier: "ipv4Format")
        }
        var bytes = Bytes()
        for component in components {
            guard let i = Int(component) else {
                throw ValidationError(message: "Invalid IP address.", identifier: "ipv4Format")
            }
            guard i >= 0 && i <= 255 else {
                throw ValidationError(message: "Invalid IP address.", identifier: "ipv4Format")
            }
            bytes.append(Byte(i))
        }
        return bytes
    }

    public static func test() {
        do {
            let bytes: Bytes = [127, 0, 0, 1]
            let encoded = IPAddress4.encode(bytes)
            assert(encoded == "127.0.0.1")
            print(encoded)
            let decoded = try IPAddress4.decode(encoded)
            assert(decoded == bytes)
            print(decoded)
        } catch(let error) {
            logError(error)
        }
    }
}
