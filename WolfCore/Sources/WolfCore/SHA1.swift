//
//  SHA1.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/20/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

#if os(Linux)
    import COpenSSL
#else
    import CommonCrypto
#endif

public struct SHA1 {
    private typealias `Self` = SHA1

    #if os(Linux)
    private static let digestLength = Int(SHA_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
    #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        #if os(Linux)
            var ctx = SHA_CTX()
            SHA1_Init(&ctx)
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) -> Void in
                self.digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) -> Void in
                    SHA1_Update(&ctx, dataPtr, data.count)
                    SHA1_Final(digestPtr, &ctx)
                }
            }
        #else
            _ = data.withUnsafeBytes { dataPtr in
                self.digest.withUnsafeMutableBytes { digestPtr in
                    return CC_SHA1(dataPtr, CC_LONG(data.count), digestPtr)
                }
            }
        #endif
    }

    public static func test() {
        // $ openssl dgst -sha1 -hex
        // The quick brown fox\n^d
        // 16d17cfbec56708a1174c123853ad609a7e67cd8
        let data = "The quick brown fox\n" |> Data.init
        let sha1 = data |> SHA1.init
        print(sha1)
        // prints 16d17cfbec56708a1174c123853ad609a7e67cd8
        let string = sha1 |> String.init
        print(string == "16d17cfbec56708a1174c123853ad609a7e67cd8")
        // prints true
    }
}

extension SHA1: CustomStringConvertible {
    public var description: String {
        return digest |> Hex.init |> String.init
    }
}

extension String {
    public init(sha1: SHA1) {
        self.init(sha1.description)!
    }
}
