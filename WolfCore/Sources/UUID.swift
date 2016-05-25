//
//  UUID.swift
//  WolfCore
//
//  Created by Robert McNally on 1/14/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import Foundation
#elseif os(Linux)
    import Glibc
    import CUUID
#endif

public struct UUID {
    private let bytes: Bytes
    private static let bufSize = 16

    public init(bytes: Bytes) {
        assert(bytes.count == UUID.bufSize)
        self.bytes = bytes
    }

    public init() {
        #if os(iOS) || os(OSX) || os(tvOS)
            self.init(bytes: UUID.convert(NSUUID()))
        #elseif os(Linux)
            let buf = UnsafeMutablePointer<UInt8>.alloc(UUID.bufSize)
            defer { buf.dealloc(UUID.bufSize) }
            uuid_generate_random(buf)
            let bytes = Bytes(UnsafeBufferPointer<Byte>(start: buf, count: UUID.bufSize))
            self.init(bytes: bytes)
        #endif
    }

    public init(string: String) throws {
        #if os(iOS) || os(OSX) || os(tvOS)
            guard let u = NSUUID(UUIDString: string) else {
                throw ValidationError(message: "Invalid UUID string: \(string).", identifier: "uuidFormat")
            }
            self.init(bytes: UUID.convert(u))
        #elseif os(Linux)
            let buf = UnsafeMutablePointer<UInt8>.alloc(UUID.bufSize)
            defer { buf.dealloc(UUID.bufSize) }
            let result = string.withCString { uuid_parse($0, buf) }
            guard result != -1 else {
                throw ValidationError(message: "Invalid UUID string: \(string).")
            }
            let bytes = Bytes(UnsafeBufferPointer<Byte>(start: buf, count: UUID.bufSize))
            self.init(bytes: bytes)
        #endif
    }

    #if os(iOS) || os(OSX) || os(tvOS)
    private static func convert(u: NSUUID) -> Bytes {
        var buf = Bytes(count: 16, repeatedValue: 0)
        u.getUUIDBytes(&buf)
        return buf
    }
    #endif
}

extension UUID: Equatable {
}

public func == (lhs: UUID, rhs: UUID) -> Bool {
    return lhs.bytes == rhs.bytes
}

extension UUID: CustomStringConvertible {
    public var description: String {
        #if os(iOS) || os(OSX) || os(tvOS)
            return NSUUID(UUIDBytes: bytes).UUIDString.lowercaseString
        #else
            let buf = UnsafeMutablePointer<Int8>.alloc(100)
            defer { buf.dealloc(100) }
            uuid_unparse_lower(bytes, buf)
            let str = String.fromCString(buf)!
            return str
        #endif
    }
}

extension UUID {
    public static func test() {
        let u = UUID()
        print(u)
        let v = try! UUID(string: u.description)
        print(v)
        print(u == v) // prints true
        let y = try! UUID(string: "6e0c369c-055e-4f26-876b-a44967ed73a1")
        print(y) // prints 6e0c369c-055e-4f26-876b-a44967ed73a1
        do {
            let z = try UUID(string: "dog")
            print(z)
        } catch(let error) {
            logError(error)
        } // prints "Invalid UUID string: "dog"."
    }
}
