//
//  StringTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import XCTest
@testable import WolfCore

class StringTests: XCTestCase {
    func testReplacing() {
        let s = "The #{subjectAdjective} #{subjectColor} #{subjectSpecies} #{action} the #{objectAdjective} #{objectSpecies}." // swiftlint:disable:this line_length
        let replacements: Replacements = [
            "subjectAdjective": "quick",
            "subjectColor": "brown",
            "subjectSpecies": "fox",
            "action": "jumps over",
            "objectAdjective": "lazy",
            "objectSpecies": "dog"
        ]
        let result = s.replacingPlaceholders(withReplacements: replacements)
        XCTAssert(result == "The quick brown fox jumps over the lazy dog.")
    }
}
