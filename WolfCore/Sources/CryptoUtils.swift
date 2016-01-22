//
//  CryptoUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 1/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import COpenSSL
#else
    import Security
#endif

public class Crypto {
    public static func generateRandomBytes(count: Int) -> Bytes {
        var bytes = Bytes(count: count, repeatedValue: 0)
#if os(Linux)
        RAND_bytes(&bytes, Int32(count))
#else
        SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
#endif
        return bytes
    }

    public static func testRandom() {
        for _ in 1...3 {
            let bytes = generateRandomBytes(50)
            print(bytes)
        }
    }
    
    public static func generateKeyPair() {
        var publicKey: SecKey?
        var privateKey: SecKey?
        let parameters: [NSString: AnyObject] = [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits: 1024]
        let result = SecKeyGeneratePair(parameters, &publicKey, &privateKey)
        print(result)
    }
}
