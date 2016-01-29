//
//  Base64URL.swift
//  WolfCore
//
//  Created by Robert McNally on 1/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class Base64URL {
    public static func encode(data: NSData) -> String {
        return base64URLStringWithBase64String(Base64.encode(data))
    }

    public static func encode(bytes: Bytes) -> String {
        return encode(ByteArray.dataWithBytes(bytes))
    }

    public static func decode(string: String) throws -> NSData {
        return try Base64.decode(base64StringWithBase64URLString(string))
    }

    public static func decode(string: String) throws -> Bytes {
        return ByteArray.bytesWithData(try decode(string))
    }

    private static func base64URLStringWithBase64String(base64String: String) -> String {
        var s2 = ""
        for c in base64String.characters {
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

    private static func base64StringWithBase64URLString(base64URLString: String) -> String {
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
