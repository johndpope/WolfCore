//
//  ExtensibleEnumeratedName.swift
//  WolfCore
//
//  Created by Robert McNally on 6/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol ExtensibleEnumeratedName: RawRepresentable, Equatable, Hashable, Comparable {
    var name: String { get }
}

public func < <T: ExtensibleEnumeratedName>(left: T, right: T) -> Bool {
    return left.name < right.name
}
