//
//  Reference.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/29/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol Reference {
    associatedtype ReferentType

    var referent: ReferentType { get }
}

postfix operator ®

public postfix func ® <T: Reference>(rhs: T) -> T.ReferentType {
    return rhs.referent
}
