//
//  CryptoUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 1/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(Linux)
    import COpenSSL
    typealias KeyRef = UnsafePointer<RSA>
    typealias Bignum = bignum_st
    typealias BignumRef = UnsafePointer<Bignum>
    typealias BignumGenCallback = bn_gencb_st
    let OPENSSL_free = CRYPTO_free
#else
    import Security
#endif

import Foundation

public struct CryptoError: Error, CustomStringConvertible {
    public let message: String
    public let code: Int?

    public init(message: String, code: Int? = nil) {
        self.message = message
        self.code = code
    }

    public var description: String {
        var c = [message]
        if let code = code {
            c.append("[\(code)]")
        }

        return "CryptoError(\(c.joinWithSeparator(" ")))"
    }

    #if os(Linux)
        public static func checkNotNil<T>(value: UnsafeMutablePointer<T>, message: String) throws -> UnsafeMutablePointer<T> {
            if value != nil {
                return value
            } else {
                let code = Int(ERR_get_error())
                throw CryptoError(message: message, code: code)
            }
        }

        public static func checkCode(ret: Int32, message: String) throws {
            if ret != 1 {
                let code = Int(ERR_get_error())
                throw CryptoError(message: message, code: code)
            }
        }
    #else
        public static func checkCode(code: OSStatus, message: String) throws {
            if code != 0 {
                throw CryptoError(message: message, code: Int(code))
            }
        }
    #endif
}

public class CryptoKey: CustomStringConvertible {
    #if os(Linux)
        private let keyRef: KeyRef

        init(keyRef: KeyRef) {
            self.keyRef = keyRef
        }

        deinit {
            RSA_free(UnsafeMutablePointer(keyRef))
        }

        static func bignumToBytes(bn: BignumRef) -> Bytes {
            let count = Int(BN_bn2mpi(bn, nil))
            var data = UnsafeMutablePointer<Byte>.alloc(count); defer {
                data.dealloc(count)
            }
            BN_bn2mpi(bn, data)
            let buffer = UnsafeBufferPointer(start: data + 4, count: count - 4)
            return Bytes(buffer)
        }

        static func bignumToDecString(bn: BignumRef) -> String {
            let sc = BN_bn2dec(bn); defer {
                OPENSSL_free(sc)
            }
            return String.fromCString(sc)!
        }

        static func bignumToBase64URL(bn: BignumRef) -> String {
            return Base64URL.encode(bignumToBytes(bn))
        }

        static func addKeyFieldAsBase64URLToDict(inout dict: JSONDictionary, field: String, value: BignumRef) {
            if value != nil {
                dict[field] = NSString(UTF8String: bignumToBase64URL(value))
            }
        }

        static func addKeyFieldAsBytesToDict(inout dict: BSONDictionary, field: String, value: BignumRef) {
            if value != nil {
                dict[field] = bignumToBytes(value)
            }
        }

        func json(onlyPublic: Bool, keyID: String? = nil) throws -> JSONDictionary {
            var dict = JSONDictionary()

            dict["kty"] = "RSA" as NSString

            if let keyID = keyID {
                dict["kid"] = NSString(UTF8String: keyID)
            }

            let r = keyRef.memory
            dict["e"] = NSNumber(integer: Int(BN_get_word(r.e)))

            self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "n", value: r.n)

            if !onlyPublic {
                self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "d", value: r.d)
                self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "p", value: r.p)
                self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "q", value: r.q)
                self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "dp", value: r.dmp1)
                self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "dq", value: r.dmq1)
                self.dynamicType.addKeyFieldAsBase64URLToDict(&dict, field: "qi", value: r.iqmp)
            }
            return dict
        }

        func bson(onlyPublic: Bool, keyID: String? = nil) throws -> BSONDictionary {
            var dict = BSONDictionary()

            dict["kty"] = Optional("RSA")
            dict["kid"] = keyID

            let r = keyRef.memory
            dict["e"] = Optional(Int(BN_get_word(r.e)))

            self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "n", value: r.n)

            if !onlyPublic {
                self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "d", value: r.d)
                self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "p", value: r.p)
                self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "q", value: r.q)
                self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "dp", value: r.dmp1)
                self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "dq", value: r.dmq1)
                self.dynamicType.addKeyFieldAsBytesToDict(&dict, field: "qi", value: r.iqmp)
            }
            return dict
        }

    #else

        private let keyRef: SecKey

        init(keyRef: SecKey) {
            self.keyRef = keyRef
        }

        func bytes() throws -> Bytes {
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
                let fieldName = fieldNames[nextFieldIndex]
                nextFieldIndex++
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
    
    func bson(onlyPublic: Bool, keyID: String? = nil) throws -> BSONDictionary {
        var dict = BSONDictionary()
        
        let bytes = try self.bytes()
        
        let fieldNames: [String] = onlyPublic ? ["n", "e"] : ["-version", "n", "e", "d", "p", "q", "dp", "dq", "qi"]
        var nextFieldIndex = 0
        
        let parser = ASN1Parser(bytes: bytes)
        
        dict["kty"] = Optional("RSA")
        dict["kid"] = keyID
        
        parser.foundBytes = { bytes in
            let fieldName = fieldNames[nextFieldIndex]
            nextFieldIndex++
            if !fieldName.hasPrefix("-") {
                if bytes.count == 3 && fieldName == "e" {
                    dict[fieldName] = Int(bytes[0]) << 16 | Int(bytes[1]) << 8 | Int(bytes[2])
                } else {
                    dict[fieldName] = bytes
                }
            }
            //println("BYTES \(fieldName) (\(bytes.count)) \(bytes)")
        }
        parser.didEndDocument = {
            //println("END DOCUMENT")
        }
        
        try parser.parse()
        
        return dict
    }
    #endif

    public var description: String {
        return "\(keyRef)"
    }
}

public class PublicKey: CryptoKey {
    public override var description: String {
        do {
            return "\(try json(true))"
        } catch(let error) {
            logError(error)
            return "invalid"
        }
    }
}

public class PrivateKey: CryptoKey {
    public override var description: String {
        do {
            return "\(try json(false))"
        } catch(let error) {
            logError(error)
            return "invalid"
        }
    }
}

public class KeyPair {
    public let publicKey: PublicKey
    public let privateKey: PrivateKey

    public init(publicKey: PublicKey, privateKey: PrivateKey) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

    #if os(Linux)
        convenience init(publicKey: KeyRef, privateKey: KeyRef) {
            self.init(publicKey: PublicKey(keyRef: publicKey), privateKey: PrivateKey(keyRef: privateKey))
        }
    #else
        convenience init(publicKey: SecKey, privateKey: SecKey) {
            self.init(publicKey: PublicKey(keyRef: publicKey), privateKey: PrivateKey(keyRef: privateKey))
        }
    #endif
}

public class Crypto {
    public static func setup() throws {
        #if os(Linux)
            ERR_load_crypto_strings()
            OPENSSL_add_all_algorithms_conf()
            OPENSSL_config(nil)
            let maxBytes = 1024
            let file = "/dev/urandom"
            let bytesRead = Int(RAND_load_file(file, maxBytes))
            if bytesRead != maxBytes {
                throw CryptoError(message: "Seeding RNG.")
            }
        #endif
    }

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

    //
    // See "How big an RSA key is considered secure today?"
    // http://crypto.stackexchange.com/questions/1978/how-big-an-rsa-key-is-considered-secure-today
    //
    static let keySize = 2048
    static let exponent = 65537

    public static func generateKeyPair() throws -> KeyPair {
        #if os(Linux)
            var cb = BignumGenCallback()
            cb.ver = 2
            cb.cb.cb_2 = { (a: Int32, b: Int32, arg: UnsafeMutablePointer<BignumGenCallback>) -> Int32 in
                // print("a: \(a), b: \(b)")
                return 1
            }

            let rsa = try CryptoError.checkNotNil(RSA_new(), message: "Allocating key pair."); defer {
                RSA_free(rsa)
            }
            let bne = try CryptoError.checkNotNil(BN_new(), message: "Allocating exponent."); defer {
                BN_free(bne)
            }
            try CryptoError.checkCode(BN_set_word(bne, UInt(exponent)), message: "Setting exponent.")
            try withUnsafeMutablePointer(&cb) { cbp in
                try CryptoError.checkCode(RSA_generate_key_ex(rsa, Int32(keySize), bne, cbp), message: "Generating key pair.")
            }
            let publicKey = RSAPublicKey_dup(rsa)
            let privateKey = RSAPrivateKey_dup(rsa)
            return KeyPair(publicKey: publicKey, privateKey: privateKey)
        #else
            var publicKey: SecKey?
            var privateKey: SecKey?
            let parameters: [NSString: AnyObject] = [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits: keySize]
            try CryptoError.checkCode(SecKeyGeneratePair(parameters, &publicKey, &privateKey), message: "Generating key pair.")
            return KeyPair(publicKey: publicKey!, privateKey: privateKey!)
        #endif
    }

    public static func testGenerateKeyPair() {
        do {
            try setup()
            let keyPair = try generateKeyPair()
            
//            let publicJSON = try keyPair.publicKey.json(true)
//            let publicJSONEncoded = try JSON.encode(publicJSON)
//            print("publicKey: count \(publicJSONEncoded.length): \(publicJSON)")
            print("publicKey:")
            let publicBSON = try keyPair.publicKey.bson(true)
            printBSONDictionary(publicBSON)
            let publicBSONBytes = try BSON.encode(publicBSON)
            print("publicBSONBytes: count \(publicBSONBytes.count): \(publicBSONBytes)")
            
//            let privateJSON = try keyPair.privateKey.json(false)
//            let privateJSONEncoded = try JSON.encode(privateJSON)
//            print("privateKey: count \(privateJSONEncoded.length): \(privateJSON)")
            print("privateKey:")
            let privateBSON = try keyPair.privateKey.bson(false)
            printBSONDictionary(privateBSON)
            let privateBSONBytes = try BSON.encode(privateBSON)
            print("privateBSONBytes: count \(privateBSONBytes.count): \(privateBSONBytes)")
        } catch(let error) {
            logError(error)
        }
    }
}
