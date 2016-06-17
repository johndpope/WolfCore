//
//  SHA256.swift
//  WolfCore
//
//  Created by Robert McNally on 1/20/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import COpenSSL
    private let sha256DigestLength = SHA256_DIGEST_LENGTH
#else
    import Foundation
    import CommonCrypto
    private let sha256DigestLength = CC_SHA256_DIGEST_LENGTH
#endif

public class SHA256 {
    private(set) var digest = Bytes(repeating: 0, count: Int(sha256DigestLength))

    public init(bytes: Bytes) {
#if os(Linux)
        var ctx = SHA256_CTX()
        SHA256_Init(&ctx)
        SHA256_Update(&ctx, bytes, bytes.count)
        SHA256_Final(&digest, &ctx)
#else
        CC_SHA256(bytes, CC_LONG(bytes.count), &digest)
#endif
    }

    public static func encode(bytes: Bytes) -> SHA256 {
        return SHA256(bytes: bytes)
    }

    public static func encode(data: Data) -> SHA256 {
        return data |> Data.bytes |> encode
    }

    public static func test() {
        // $ openssl dgst -sha256 -hex
        // The quick brown fox\n^d
        // 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        let data = "The quick brown fox\n" |> String.utf8Data
        let sha256 = data |> encode
        print(sha256)
        // prints 35fb7cc2337d10d618a1bad35c7a9e957c213f0d0ed32f2454b2a99a971c0d8
        print(sha256.description == "35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8")
        // prints true
    }
}

extension SHA256: CustomStringConvertible {
    public var description: String {
        return digest |> Bytes.hex
    }
}
