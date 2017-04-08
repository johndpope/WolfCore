//
//  RegexUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

// Regex matching operators

infix operator ~?
infix operator ~??

public func ~?? (regex: NSRegularExpression, str: String) -> [NSTextCheckingResult] {
    return regex.matches(in: str, options: [], range: str.nsRange)
}

public func ~? (regex: NSRegularExpression, str: String) -> Bool {
    return (regex ~?? str).count > 0
}

// Regex creation operator

prefix operator ~/

public prefix func ~/ (pattern: String) throws -> NSRegularExpression {
    return try NSRegularExpression(pattern: pattern, options: [])
}

public func testRegex() -> Bool {
    let regex = try! ~/"\\wpple"
    let str = "Foo"

    return regex ~? str
}
