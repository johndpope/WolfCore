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
public struct Base64URL {
    /// Encodes the Data as a base-64 URL encoded string. May be used to transform
    /// a string as a monad.
    ///
    ///     let data = "Hello there." |> UTF8.encode
    ///     let base64URLString = data |> Base64URL.encode
    ///
    /// - parameter data: The data to be base-64 URL encoded.
    /// - returns: A base-64 URL encoded `String`.
    public static func encode(_ data: Data) -> String {
        return data |> Base64.encode |> toBase64URL
    }

    /// Decodes the base-64 URL encoded string to a `Data`. May be used to transform
    /// the `Data` as a monad.
    ///
    ///     let data = "Hello there." |> UTF8.encode
    ///     let base64URLString = data |> Base64URL.encode
    ///     let data2 = try! base64String |> Base64URL.encode.decode
    ///
    /// - parameter string: The string to be decoded from base-64.
    /// - returns: A `Data` containing the decoded data.
    /// - throws: A ValidationError if the String is not well-formed base-64.
    public static func decode(_ string: String) throws -> Data {
        return try string |> toBase64 |> Base64.decode
    }

    private static func toBase64URL(string: String) -> String {
        var s2 = ""
        for c in string.characters {
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

    private static func toBase64(string: String) -> String {
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
        return s2
    }
}
