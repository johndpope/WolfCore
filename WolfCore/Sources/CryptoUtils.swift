//
//  CryptoUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 1/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Security

public class Crypto {
    public static func generateRandomBytes(count: Int) -> Bytes {
        var bytes = Bytes(count: count, repeatedValue: 0)
        SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        return bytes
    }
    
    public static func testRandom() {
        for _ in 1...10 {
            let bytes = generateRandomBytes(100)
            print(bytes)
        }
    }
}
