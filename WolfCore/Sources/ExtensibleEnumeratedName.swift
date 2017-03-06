//
//  ExtensibleEnumeratedName.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol ExtensibleEnumeratedName: RawRepresentable, Equatable, Hashable, Comparable {
    associatedtype ValueType: Comparable
    var name: ValueType { get }
}

public func < <T: ExtensibleEnumeratedName>(left: T, right: T) -> Bool {
    return left.name < right.name
}
