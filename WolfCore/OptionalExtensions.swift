//
//  OptionalExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

//  The purpose of the † (dagger) postfix operator (typed by pressing option-t) is to create a string representation of an optional value that is the unwrapped version of the value if it is not nil, and simply "nil" if it is.
//
//    var a: Int?
//
//    print(a)          // prints "nil", also has warning, "Expression implicitly coerced from 'Int?' to Any"
//    print("\(a)")     // prints "nil"
//    print(a†)         // prints "nil"
//
//    a = 5
//
//    print(a)          // prints "Optional(5)", also has warning, "Expression implicitly coerced from 'Int?' to Any"
//    print("\(a)")     // prints "Optional(5)"
//    print(a†)         // prints "5"

fileprivate protocol _Optional {
    func unwrappedString() -> String
}

extension Optional: _Optional {
    fileprivate func unwrappedString() -> String {
        switch self {
        case .some(let wrapped as _Optional): return wrapped.unwrappedString()
        case .some(let wrapped): return String(describing: wrapped)
        case .none: return String(describing: self)
        }
    }
}

postfix operator †
public postfix func † <X> (x: X?) -> String {
    return x.unwrappedString()
}
