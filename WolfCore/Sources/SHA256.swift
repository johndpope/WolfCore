//
//  SHA256.swift
//  WolfCore
//
//  Created by Robert McNally on 1/20/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import CommonCrypto

public class SHA256 {
    private(set) var digest = Bytes(count: 32, repeatedValue: 0)
    
    public init(var bytes: Bytes) {
        CC_SHA256(&bytes, CC_LONG(bytes.count), &digest)
    }
    
//    func test() {
//        let data = NSData()
//        var hash = Bytes(count: 32, repeatedValue: 0)
//        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
//        var res : NSData = NSData.dataWithBytes(hash, length: Int(CC_SHA256_DIGEST_LENGTH))
//    }
}

