//
//  Base64URL.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension Data {
    public static func base64URL(from data: Data) -> String {
        return data |> Data.base64 |> String.base64URL
    }
}

extension Array {
    public static func base64URL(from bytes: Bytes) -> String {
        return bytes |> Bytes.data |> Data.base64URL
    }
}

public struct Base64URL {
    public static func data(from base64URLString: String) throws -> Data {
        return try base64URLString |> String.base64 |> Base64.data
    }
}

extension String {
    private static func base64URL(withBase64String string: String) -> String {
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

    private static func base64(withBase64URLString base64URLString: String) -> String {
        var s2 = ""
        let chars = base64URLString.characters
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
