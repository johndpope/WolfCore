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

public struct CryptoError: Error, CustomStringConvertible {
    public let code: Int
    public let message: String
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }

    public var description: String {
        return "CryptoError([\(code)] \(message))"
    }
    
    public static func checkCode(code: OSStatus, message: String) throws {
        if code != 0 {
            throw CryptoError(code: Int(code), message: message)
        }
    }
}

public class CryptoKey {
    private let keyRef: SecKey
    
    public init(keyRef: SecKey) {
        self.keyRef = keyRef
    }
    
    private func bytes() throws -> Bytes {
        let tag = "tempkey.\(UUID())"
        let tagData: NSData = UTF8.encode(tag)
        
        let query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag: tagData
        ]
        
        var attributes = query
        attributes[kSecValueRef] = keyRef
        attributes[kSecReturnData] = true
        
        var item: AnyObject?
        try CryptoError.checkCode(SecItemAdd(attributes, &item), message: "Adding temp key to keychain.")
        let keyInfo = item! as! NSData
        try CryptoError.checkCode(SecItemDelete(query), message: "Deleting temp key from keychain.")
        return ByteArray.bytesWithData(keyInfo)
    }
    
    func json(onlyPublic: Bool, keyID: String? = nil) throws -> JSONDictionary {
        var dict = JSONDictionary()
        
        let bytes = try self.bytes()
        
        let fieldNames: [String] = onlyPublic ? ["n", "e"] : ["-version", "n", "e", "d", "p", "q", "dp", "dq", "qi"]
        var nextFieldIndex = 0
        
        let parser = ASN1Parser(bytes: bytes)
        
        dict["kty"] = "RSA"
        
        if let kid = keyID {
            dict["kid"] = kid
        }
        
        parser.foundBytes = { bytes in
            let fieldName = fieldNames[nextFieldIndex++]
            if !fieldName.hasPrefix("-") {
                dict[fieldName] = Base64URL.encode(bytes)
            }
            //println("BYTES \(fieldName) (\(bytes.count)) \(bytes)")
        }
        parser.didEndDocument = {
            //println("END DOCUMENT")
        }
        
        try parser.parse()
        
        return dict
    }
}

extension CryptoKey: CustomStringConvertible {
    public var description: String {
        return Hex.encode(try! bytes())
    }
}

public class PublicKey: CryptoKey {
}

public class PrivateKey: CryptoKey {
}

public class KeyPair {
    public let publicKey: PublicKey
    public let privateKey: PrivateKey
    
    public init(publicKey: PublicKey, privateKey: PrivateKey) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    public convenience init(publicKey: SecKey, privateKey: SecKey) {
        self.init(publicKey: PublicKey(keyRef: publicKey), privateKey: PrivateKey(keyRef: privateKey))
    }
}

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
    
    public static func generateKeyPair() throws -> KeyPair {
        //
        // See "How big an RSA key is considered secure today?"
        // http://crypto.stackexchange.com/questions/1978/how-big-an-rsa-key-is-considered-secure-today
        //
        let keySize = 2048
        var publicKey: SecKey?
        var privateKey: SecKey?
        let parameters: [NSString: AnyObject] = [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits: keySize]
        try CryptoError.checkCode(SecKeyGeneratePair(parameters, &publicKey, &privateKey), message: "Generating key pair.")
        return KeyPair(publicKey: publicKey!, privateKey: privateKey!)
    }
    
    public static func testGenerateKeyPair() {
        do {
            let keyPair = try generateKeyPair()
            print("publicKey: \(keyPair.publicKey)")
            print("privateKey: \(keyPair.privateKey)")
        } catch(let error) {
            logError(error)
        }
    }
}
