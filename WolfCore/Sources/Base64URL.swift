//
//  Base64URL.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct Base64URL {
    public static func encode(_ data: Data) -> String {
        return data |> Base64.encode |> toBase64URL
    }

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
