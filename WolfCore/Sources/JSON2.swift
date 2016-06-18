//
//  JSON2.swift
//  WolfCore
//
//  Created by Robert McNally on 6/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public final class JSON2 {
    public typealias Value = Any
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]

    private static let space: Character = " "
    private static let tab: Character = "\t"
    private static let newline: Character = "\n"
    private static let carriageReturn: Character = "\r"

    private static let openBracket: Character = "["
    private static let closeBracket: Character = "]"
    private static let openBrace: Character = "{"
    private static let closeBrace: Character = "}"
    private static let comma: Character = ","
    private static let colon: Character = ":"

    private static let quoteMark: Character = "\""
    private static let reverseSolidus: Character = "\\"

    private static let literalFalse = "false"
    private static let literalTrue = "true"
    private static let literalNull = "null"

    public class Null {
        private init() { }
    }

    static public let null = Null()

    public final class Reader {
        private let string: String
        private var index: String.Index

        public enum Error: String, ErrorProtocol {
            case noTopLevelObjectOrArray = "No top level object or array."
            case unexpectedEndOfData = "Unexpected end of data."
            case unknownValue = "Unknown value."
            case unterminatedArray = "Unterminated array."
            case keyExpected = "Key expected."
            case nameSeparatorExpected = "Name separator expected."
            case unterminatedDictionary = "Unterminated dictionary."
            case unterminatedString = "Unterminated string."
            case unterminatedEscapeSequence = "Unterminated escape sequence."
            case unknownEscapeSequence = "Unknown escape sequence."
            case malformedNumber = "Malformed number."
        }

        private init(string: String) {
            self.string = string
            index = string.startIndex
        }

        private var hasMore: Bool {
            return index != string.endIndex
        }

        private var nextCharacter: Character {
            return string[index]
        }

        private func advance() {
            index = string.index(after: index)
        }

        private func advance(by offset: Int) {
            index = string.index(index, offsetBy: offset)
        }

        private func advance(ifNextCharacterIs character: Character) -> Bool {
            guard hasMore else { return false }
            if character == nextCharacter {
                advance()
                return true
            }
            return false
        }

        private func advance(ifNextCharacterIsNot character: Character) -> Bool {
            guard hasMore else { return false }
            if character != nextCharacter {
                advance()
                return true
            }
            return false
        }

        private func advance(ifNextCharacterIsIn characters: [Character]) -> Bool {
            guard hasMore else { return false }
            if characters.contains(nextCharacter) {
                advance()
                return true
            }
            return false
        }

        private static let whitespace = [JSON2.space, JSON2.tab, JSON2.newline, JSON2.carriageReturn]

        private func skipWhitespace() throws {
            repeat { } while advance(ifNextCharacterIsIn: Reader.whitespace)
            guard hasMore else { throw Error.unexpectedEndOfData }
        }

        private func parseValue(allowsFragment: Bool = true) throws -> JSON2.Value {
            try skipWhitespace()

            if let array = try parseArray() {
                return array
            }

            if let dictionary = try parseDictionary() {
                return dictionary
            }

            guard allowsFragment else { throw Error.noTopLevelObjectOrArray }

            if let string = try parseString() {
                return string
            }

            if let number = try parseNumber() {
                return number
            }

            if let bool = try parseBool() {
                return bool
            }

            if try parseNull() {
                return JSON2.null
            }

            throw Error.unknownValue
        }

        private func parseArray() throws -> JSON2.Array? {
            guard advance(ifNextCharacterIs: JSON2.openBracket) else { return nil }
            var array = JSON2.Array()
            repeat {
                try skipWhitespace()
                let value = try parseValue()
                array.append(value)
                try skipWhitespace()
            } while advance(ifNextCharacterIs: JSON2.comma)
            try skipWhitespace()
            guard advance(ifNextCharacterIs: JSON2.closeBracket) else { throw Error.unterminatedArray }
            return array
        }

        private func parseDictionary() throws -> JSON2.Dictionary? {
            guard advance(ifNextCharacterIs: JSON2.openBrace) else { return nil }
            var dictionary = JSON2.Dictionary()
            repeat {
                try skipWhitespace()
                guard let key = try parseString() else { throw Error.keyExpected }
                try skipWhitespace()
                guard advance(ifNextCharacterIs: JSON2.colon) else { throw Error.nameSeparatorExpected }
                try skipWhitespace()
                let value = try parseValue()
                dictionary[key] = value
                try skipWhitespace()
            } while advance(ifNextCharacterIs: JSON2.comma)
            try skipWhitespace()
            guard advance(ifNextCharacterIs: JSON2.closeBrace) else { throw Error.unterminatedDictionary }
            return dictionary
        }

        private func parseString() throws -> String? {
            guard advance(ifNextCharacterIs: JSON2.quoteMark) else { return nil }
            var string = ""
            repeat {
                guard hasMore else { throw Error.unterminatedString }
                let character = nextCharacter
                advance()
                switch character {
                case JSON2.quoteMark:
                    return string
                case JSON2.reverseSolidus:
                    string.append(try parseEscapeSequence())
                default:
                    string.append(character)
                }
            } while true
        }

        private func parseEscapeSequence() throws -> Character {
            guard hasMore else { throw Error.unterminatedEscapeSequence }
            let character = nextCharacter
            advance()
            switch character {
            case JSON2.quoteMark:
                return JSON2.quoteMark
            case JSON2.reverseSolidus:
                return JSON2.reverseSolidus
            case "t":
                return JSON2.tab
            case "n":
                return JSON2.newline
            case "r":
                return JSON2.carriageReturn
            default:
                throw Error.unknownEscapeSequence
            }
        }

        private static let numberPrefixRegex = try! ~/"^[0-9-]"
        private static let numberRegex = try! ~/"^-?(0|([1-9][0-9]*))(\\.[0-9]+)?(e[+-][0-9]+)?"

        private func parseNumber() throws -> Double? {
            let substring = string.substring(from: index)
            guard Reader.numberPrefixRegex ~? substring else { return nil }
            let matches = Reader.numberRegex ~?? substring
            guard let firstMatch = matches.first else { throw Error.malformedNumber }
            let (_, numberStr) = firstMatch.get(atIndex: 0, inString: substring)
            advance(by: numberStr.characters.count)
            guard let value = Double(numberStr) else { throw Error.malformedNumber }
            return value
        }

        private func parseBool() throws -> Bool? {
            if string.hasPrefix(JSON2.literalTrue) {
                advance(by: JSON2.literalTrue.characters.count)
                return true
            } else if string.hasPrefix(JSON2.literalFalse) {
                advance(by: JSON2.literalFalse.characters.count)
                return false
            }
            return nil
        }

        private func parseNull() throws -> Bool {
            if string.hasPrefix(JSON2.literalNull) {
                advance(by: JSON2.literalNull.characters.count)
                return true
            }
            return false
        }
    }

    public static func object(from string: String, allowsFragment: Bool = false) throws -> Value {
        let reader = Reader(string: string)
        return try reader.parseValue(allowsFragment: allowsFragment)
    }
}

public func JSON2Test() {
    let raw = "[]"
    let json = raw |> JSON2.object
    print(raw)
    print(json)
}
