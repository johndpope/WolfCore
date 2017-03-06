//
//  Base64Tests.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import XCTest
@testable import WolfCore

class Base64Tests: XCTestCase {
    let knownData = Data(bytes: Array(150..<200))
    let knownString = "lpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsc="

    func testDataToBase64() {
        let base64 = knownData |> Base64.init
        XCTAssert(base64.data == knownData)
        XCTAssert(base64.string == knownString)
    }

    func testBase64ToData() {
        let data = try! knownString |> Base64.init |> Data.init
        XCTAssert(data == knownData)
    }

    func testBase64ToString() {
        let string = try! knownString |> Base64.init |> String.init
        XCTAssert(string == knownString)
    }
}
