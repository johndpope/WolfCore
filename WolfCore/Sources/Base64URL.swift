//
//  Base64URL.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding data as Base-64 URL encoded strings.
///
/// For more information: [Base64URL on Wikipedia](https://en.wikipedia.org/wiki/Base64#URL_applications)
public struct Base64URL: RawRepresentable {
    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(string: String) {
        self.rawValue = string
    }

    public init(base64: Base64) {
        self.init(string: base64 |> Base64URL.toBase64URL)
    }

    public init(data: Data) {
        self.init(base64: data |> Base64.init)
    }

    public func data() throws -> Data {
        return try rawValue |> Base64URL.toBase64 |> Base64.data
    }

    public func string() -> String {
        return rawValue
    }
}

extension Base64URL {
    private static func toBase64URL(base64: Base64) -> String {
        var s2 = ""
        for c in base64.rawValue.characters {
            switch c {
            case Character("+"):
                s2.append(Character("_"))
            case Character("/"):
                s2.append(Character("-"))
            case Character("="):
                break
            default:
                s2.append(c)
            }
        }
        return s2
    }

    private static func toBase64(string: String) -> Base64 {
        var s2 = ""
        let chars = string.characters
        for c in chars {
            switch c {
            case Character("_"):
                s2.append(Character("+"))
            case Character("-"):
                s2.append(Character("/"))
            default:
                s2.append(c)
            }
        }
        switch chars.count % 4 {
        case 2:
            s2 += "=="
        case 3:
            s2 += "="
        default:
            break
        }
        return Base64(string: s2)
    }
}
