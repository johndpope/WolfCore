//
//  UUID.swift
//  WolfCore
//
//  Created by Robert McNally on 1/14/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct UUID {
    private let bytes: Bytes

    public init(bytes: Bytes) {
        assert(bytes.count == 16)
        self.bytes = bytes
    }
    
    public init() {
        self.init(bytes: UUID.convert(NSUUID()))
    }
    
    public init?(string: String) {
        guard let u = NSUUID(UUIDString: string) else { return nil }
        self.init(bytes: UUID.convert(u))
    }
    
    private static func convert(u: NSUUID) -> Bytes {
        var buf = Bytes(count: 16, repeatedValue: 0)
        u.getUUIDBytes(&buf)
        return buf
    }
}

extension UUID: Equatable {
}

public func ==(lhs: UUID, rhs: UUID) -> Bool {
    return lhs.bytes == rhs.bytes
}

extension UUID: CustomStringConvertible {
    public var description: String {
        return NSUUID(UUIDBytes: bytes).UUIDString.lowercaseString
    }
}

extension UUID {
    public static func test() {
        let u = UUID()
        print(u)
        let v = UUID(string: u.description)!
        print(v)
        print(u == v)
    }
}
