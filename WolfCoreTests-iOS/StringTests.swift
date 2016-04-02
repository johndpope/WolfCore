//
//  StringTests.swift
//  WolfCore
//
//  Created by Robert McNally on 4/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import XCTest
import WolfCore

class StringTests: XCTestCase {
    func testReplacing() {
        let s = "The #{subjectAdjective} #{subjectColor} #{subjectSpecies} #{action} the #{objectAdjective} #{objectSpecies}."
        let replacements: [String: Any] = [
            "subjectAdjective": "quick",
            "subjectColor": "brown",
            "subjectSpecies": "fox",
            "action": "jumps over",
            "objectAdjective": "lazy",
            "objectSpecies": "dog"
        ]
        let result = s.replacing(placeholdersWithReplacements: replacements)
        XCTAssert(result == "The quick brown fox jumps over the lazy dog.")
    }
}
