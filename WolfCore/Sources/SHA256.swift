//
//  SHA256.swift
//  WolfCore
//
//  Created by Robert McNally on 1/20/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import COpenSSL
#else
    import CommonCrypto
    private let SHA256_DIGEST_LENGTH = CC_SHA256_DIGEST_LENGTH
#endif

public class SHA256 {
    private(set) var digest = Bytes(count: Int(SHA256_DIGEST_LENGTH), repeatedValue: 0)

    public init(message: Bytes) {
#if os(Linux)
        var ctx = SHA256_CTX()
        SHA256_Init(&ctx)
        SHA256_Update(&ctx, message, message.count)
        SHA256_Final(&digest, &ctx)
#else
        CC_SHA256(message, CC_LONG(message.count), &digest)
#endif
    }

    public static func test() {
        // $ openssl dgst -sha256 -hex
        // The quick brown fox\n^d
        // 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        let message: Bytes = UTF8.encode("The quick brown fox\n")
        let sha256 = SHA256(message: message)
        print(sha256)
        // prints 35fb7cc2337d10d618a1bad35c7a9e957c213f0d0ed32f2454b2a99a971c0d8
        print(sha256.description == "35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8")
        // prints true
    }
}

extension SHA256: CustomStringConvertible {
    public var description: String {
        return Hex.encode(digest)
    }
}
