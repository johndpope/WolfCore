//
//  ExtensibleEnumeratedName.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol ExtensibleEnumeratedName: RawRepresentable, Equatable, Hashable, Comparable {
    associatedtype ValueType: Hashable, Comparable
    var name: ValueType { get }
}

extension ExtensibleEnumeratedName {
    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public var rawValue: ValueType { return name }
    // You must still provide this constructor:
    // public init?(rawValue: String) { self.init(rawValue) }
}

public func < <T: ExtensibleEnumeratedName>(left: T, right: T) -> Bool {
    return left.name < right.name
}
