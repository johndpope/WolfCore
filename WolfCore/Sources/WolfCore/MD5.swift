//
//  MD5.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

#if os(Linux)
    import COpenSSL
#else
    import CommonCrypto
#endif

public struct MD5 {
    private typealias `Self` = MD5

    #if os(Linux)
        private static let digestLength = Int(MD5_DIGEST_LENGTH)
    #else
        private static let digestLength = Int(CC_MD5_DIGEST_LENGTH)
    #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        #if os(Linux)
            var ctx = MD5_CTX()
            MD5_Init(&ctx)
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) -> Void in
                self.digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) -> Void in
                    MD5_Update(&ctx, dataPtr, data.count)
                    MD5_Final(digestPtr, &ctx)
                }
            }
        #else
            _ = data.withUnsafeBytes { dataPtr in
                self.digest.withUnsafeMutableBytes { digestPtr in
                    return CC_MD5(dataPtr, CC_LONG(data.count), digestPtr)
                }
            }
        #endif
    }

    public static func test() {
        // $ openssl dgst -md5 -hex
        // The quick brown fox\n^d
        // e480132c9dd53e3e34e3cf9f523c7425
        let data = "The quick brown fox\n" |> Data.init
        let md5 = data |> MD5.init
        print(md5)
        // prints e480132c9dd53e3e34e3cf9f523c7425
        let string = md5 |> String.init
        print(string == "e480132c9dd53e3e34e3cf9f523c7425")
        // prints true
    }
}

extension MD5: CustomStringConvertible {
    public var description: String {
        return digest |> Hex.init |> String.init
    }
}

extension String {
    public init(md5: MD5) {
        self.init(md5.description)!
    }
}
