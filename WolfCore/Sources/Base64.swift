//
//  Base64.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding data as Base-64 encoded strings.
///
/// For more information: [Base64 on Wikipedia](https://en.wikipedia.org/wiki/Base64)
public struct Base64 {
    /// Encodes the Data as a base-64 encoded string. May be used to transform
    /// a string as a monad.
    ///
    ///     let data = "Hello there." |> UTF8.encode
    ///     let base64String = data |> Base64.encode
    ///
    /// - parameter data: The data to be base-64 encoded.
    /// - returns: A base-64 encoded `String`.
    public static func encode(_ data: Data) -> String {
        return data.base64EncodedString()
    }

    /// Decodes the base-64 encoded string to a `Data`. May be used to transform
    /// the `Data` as a monad.
    ///
    ///     let data = "Hello there." |> UTF8.encode
    ///     let base64String = data |> Base64.encode
    ///     let data2 = try! base64String |> Base64.decode
    ///
    /// - parameter string: The string to be decoded from base-64.
    /// - returns: A `Data` containing the decoded data.
    /// - throws: A ValidationError if the String is not well-formed base-64.
    public static func decode(_ string: String) throws -> Data {
        if let data = Data(base64Encoded: string) {
            return data
        } else {
            throw ValidationError(message: "Invalid base64 string.", violation: "base64Format")
        }
    }
}
