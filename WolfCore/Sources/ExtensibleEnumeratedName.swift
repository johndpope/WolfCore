//
//  ExtensibleEnumeratedName.swift
//  WolfCore
//
//  Created by Robert McNally on 6/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol ExtensibleEnumeratedName: RawRepresentable, Equatable, Hashable, Comparable {
    associatedtype ReferentType

    var name: String { get }

    var referent: ReferentType { get }
}

public func < <T: ExtensibleEnumeratedName>(left: T, right: T) -> Bool {
    return left.name < right.name
}

postfix operator ® { }

public postfix func ® <T: ExtensibleEnumeratedName>(rhs: T) -> T.ReferentType {
    return rhs.referent
}
