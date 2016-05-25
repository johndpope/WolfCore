//
//  RegexUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

// Regex matching operators

public func ~= (pattern: NSRegularExpression, str: String) -> Bool {
    return pattern.numberOfMatchesInString(str, options: [], range: NSRange(location: 0, length: str.characters.count)) > 0
}

public func ~= (str: String, pattern: NSRegularExpression) -> Bool {
    return pattern.numberOfMatchesInString(str, options: [], range: NSRange(location: 0, length: str.characters.count)) > 0
}

// Regex creation operator

prefix operator ~/ {}

prefix func ~/ (pattern: String) throws -> NSRegularExpression {
    return try NSRegularExpression(pattern: pattern, options: [])
}

public func testRegex() -> Bool {
    let regex = try! ~/"\\wpple"
    let str = "Foo"

    return regex ~= str
}
