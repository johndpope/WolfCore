//
//  JSONUtilsTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/5/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import XCTest
@testable import WolfCore

public class JSONUtilsTests: XCTestCase {
    func test1() {
        let google = "https://google.com/"
        let googleURL = URL(string: google)!
        let appleURL = URL(string: "https://apple.com/")!

        let dict: JSON.Dictionary = [
            "name": "Fred",
            "nickname": JSON.null,
            "age": 21,
            "perceivedAge": JSON.null,
            "red": "#FF0000",
            "squant": JSON.null,
            "google": google,
            "2all": JSON.null,
            ]

        XCTAssert(try JSON.value(for: "nickname", in: dict) == nil)
        XCTAssert(try JSON.value(for: "sex", in: dict) == nil)
        XCTAssert(try JSON.value(for: "age", in: dict) == 21)
        XCTAssertThrowsError(try JSON.value(for: "age", in: dict) == "twentyOne")

        XCTAssert(try JSON.value(for: "sex", in: dict, fallback: "m") == "m")
        XCTAssertThrowsError(try JSON.value(for: "age", in: dict, fallback: "m") == "m")

        XCTAssert(try JSON.value(for: "name", in: dict) == "Fred")
        XCTAssert(try JSON.value(for: "name", in: dict, fallback: "Jim") == "Fred")

        XCTAssert(try JSON.string(for: "nickname", in: dict) == nil)
        XCTAssert(try JSON.string(for: "nickname", in: dict, fallback: "Mutt") == "Mutt")
        XCTAssertThrowsError(try JSON.string(for: "nickname", in: dict, fallback: nil) == "Mutt")

        XCTAssert(try JSON.string(for: "nonexistentKey", in: dict) == nil)
        XCTAssert(try JSON.string(for: "nonexistentKey", in: dict, fallback: "Mutt") == "Mutt")
        XCTAssertThrowsError(try JSON.string(for: "nonexistentKey", in: dict, fallback: nil) == "Mutt")


        XCTAssert(try JSON.int(for: "age", in: dict) == 21)
        XCTAssert(try JSON.int(for: "age", in: dict, fallback: 18) == 21)
        XCTAssert(try JSON.int(for: "age", in: dict, fallback: nil) == 21)

        XCTAssert(try JSON.int(for: "perceivedAge", in: dict) == nil)
        XCTAssert(try JSON.int(for: "perceivedAge", in: dict, fallback: 18) == 18)
        XCTAssertThrowsError(try JSON.int(for: "perceivedAge", in: dict, fallback: nil) == 18)

        XCTAssert(try JSON.int(for: "nonexistentKey", in: dict) == nil)
        XCTAssert(try JSON.int(for: "nonexistentKey", in: dict, fallback: 18) == 18)
        XCTAssertThrowsError(try JSON.int(for: "nonexistentKey", in: dict, fallback: nil) == 18)


        XCTAssert(try JSON.color(for: "red", in: dict) == .red)
        XCTAssert(try JSON.color(for: "red", in: dict, fallback: .blue) == .red)
        XCTAssert(try JSON.color(for: "red", in: dict, fallback: nil) == .red)

        XCTAssert(try JSON.color(for: "squant", in: dict) == nil)
        XCTAssert(try JSON.color(for: "squant", in: dict, fallback: .blue) == .blue)
        XCTAssertThrowsError(try JSON.color(for: "squant", in: dict, fallback: nil) == .blue)

        XCTAssert(try JSON.color(for: "nonexistentKey", in: dict) == nil)
        XCTAssert(try JSON.color(for: "nonexistentKey", in: dict, fallback: .blue) == .blue)
        XCTAssertThrowsError(try JSON.color(for: "nonexistentKey", in: dict, fallback: nil) == .blue)


        XCTAssert(try JSON.url(for: "google", in: dict) == googleURL)
        XCTAssert(try JSON.url(for: "google", in: dict, fallback: appleURL) == googleURL)
        XCTAssert(try JSON.url(for: "google", in: dict, fallback: nil) == googleURL)

        XCTAssert(try JSON.url(for: "2all", in: dict) == nil)
        XCTAssert(try JSON.url(for: "2all", in: dict, fallback: appleURL) == appleURL)
        XCTAssertThrowsError(try JSON.url(for: "2all", in: dict, fallback: nil) == appleURL)

        XCTAssert(try JSON.url(for: "nonexistentKey", in: dict) == nil)
        XCTAssert(try JSON.url(for: "nonexistentKey", in: dict, fallback: appleURL) == appleURL)
        XCTAssertThrowsError(try JSON.url(for: "nonexistentKey", in: dict, fallback: nil) == appleURL)
    }
}
