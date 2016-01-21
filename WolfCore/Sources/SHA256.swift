//
//  SHA256.swift
//  WolfCore
//
//  Created by Robert McNally on 1/20/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import CommonCrypto

public class SHA256 {
    private(set) var digest = Bytes(count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
    
    public init(message: Bytes) {
        CC_SHA256(message, CC_LONG(message.count), &digest)
    }
}

extension SHA256: CustomStringConvertible {
    public var description: String {
        var s = ""
        for byte in digest {
            s += String(byte, radix: 16)
        }
        return s
    }
}

public func testSHA256() {
    // $ openssl dgst -sha256 -hex
    // The quick brown fox\n^d
    // 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
    let message = "The quick brown fox\n".bytes
    let sha256 = SHA256(message: message)
    print(sha256)
    // prints 35fb7cc2337d10d618a1bad35c7a9e957c213f0d0ed32f2454b2a99a971c0d8
}
