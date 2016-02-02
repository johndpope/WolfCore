//
//  NetworkUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Glibc

public enum IPAddressType: Int {
    case Version4 = 2 // AF_INET
    case Version6 = 10 // AF_INET6
}

public struct NetworkError: Error, CustomStringConvertible {
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

        return "NetworkError(\(c.joinWithSeparator(" ")))"
    }

    #if os(Linux)
        // public static func checkNotNil<T>(value: UnsafeMutablePointer<T>, message: String) throws -> UnsafeMutablePointer<T> {
        //     if value != nil {
        //         return value
        //     } else {
        //         let code = Int(ERR_get_error())
        //         throw CryptoError(message: message, code: code)
        //     }
        // }

        public static func checkCode(ret: Int32, message: String) throws {
            guard ret == 0 else {
                throw NetworkError(message: message, code: Int(ret))
            }
        }
    #endif
}

public class Host {
    public let hostname: String
    public let port: Int
    public private(set) var officialHostname: String!
    public private(set) var aliases = [String]()

    public init(hostname: String, port: Int = 0) {
        self.hostname = hostname
        self.port = port
    }

    public func resolveForAddressType(addressType: IPAddressType) throws {
        var hostent_p = UnsafeMutablePointer<hostent>.alloc(1)
        defer { hostent_p.dealloc(1) }

        let buflen = 2048
        var buf_p = UnsafeMutablePointer<Byte>.alloc(buflen)
        defer { buf_p.dealloc(buflen) }

        var result_p = UnsafeMutablePointer<HostEntRef>.alloc(1)
        defer { result_p.dealloc(1) }

        var errno_p = UnsafeMutablePointer<Int32>.alloc(1)
        defer { errno_p.dealloc(1) }

        try NetworkError.checkCode(
            gethostbyname2_r(
                hostname,
                Int32(addressType.rawValue),
                hostent_p,
                UnsafeMutablePointer(buf_p),
                buflen,
                result_p,
                errno_p
            ),
        message: "Resolving address.")

        officialHostname = String.fromCString(hostent_p.memory.h_name)!

        var nextAlias_p = hostent_p.memory.h_aliases
        while nextAlias_p.memory != nil {
            let alias = String.fromCString(UnsafePointer(nextAlias_p.memory))!
            aliases.append(alias)
            nextAlias_p += 1
        }
    }
}
