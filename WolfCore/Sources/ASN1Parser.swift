//
//  ASN1Parser.swift
//  WolfCore
//
//  Created by Robert McNally on 1/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct ASN1Error: Error {
    public let message: String
    public let code: Int

    public init(_ message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }

    public var identifier: String {
        return "ASN1Error(\(code))"
    }
}

extension ASN1Error: CustomStringConvertible {
    public var description: String {
        return "ASN1Error(\(message))"
    }
}

class ASN1BitString: CustomStringConvertible {
    let data: Bytes
    let unusedBits: Int
    let numberOfBits: Int

    init(data: Bytes, unusedBits: Int) {
        self.data = data
        self.unusedBits = unusedBits
        numberOfBits = data.count * 8 - unusedBits
    }

    var description: String {
        get {
            return "data: \(data.description) unusedBits:\(unusedBits)"
        }
    }

    var stringWithBits: String {
        get {
            var s = String()
            for bitIndex in 0..<numberOfBits {
                let c: Character = bit(at: bitIndex) ? "1" : "0"
                s.append(c)
            }
            return s
        }
    }

    func bit(at index: Int) -> Bool {
        assert(index >= 0 && index < numberOfBits)

        let byteIndex = index / 8
        let bitIndexInByte = 7 - index % 8
        let bit = data[byteIndex] & Byte(1 << bitIndexInByte)
        return bit != 0
    }
}

enum ASN1Type: Byte, CustomStringConvertible {
    case eoc = 0x00
    case boolean = 0x01
    case integer = 0x02
    case bitString = 0x03
    case octetString = 0x04
    case null = 0x05
    case objectIdentifier = 0x06
    case objectDescriptor = 0x07
    case external = 0x08
    case real = 0x09
    case enumerated = 0x0a
    case embeddedPDV = 0x0b
    case utf8String = 0x0c
    case sequence = 0x10
    case set = 0x11
    case numericString = 0x12
    case printableString = 0x13
    case teletexString = 0x14
    case videoTextString = 0x15
    case ia5String = 0x16
    case utcTime = 0x17
    case generalizedTime = 0x18
    case graphicString = 0x19
    case visibleString = 0x1a
    case generalString = 0x1b
    case universalString = 0x1c
    case bitmapString = 0x1e
    case usesLongForm = 0x1f

    var description: String {
        get {
            switch self {
            case .eoc: return "eoc"
            case .boolean: return "boolean"
            case .integer: return "integer"
            case .bitString: return "bitString"
            case .octetString: return "octetString"
            case .null: return "null"
            case .objectIdentifier: return "objectIdentifier"
            case .objectDescriptor: return "objectDescriptor"
            case .external: return "external"
            case .real: return "real"
            case .enumerated: return "enumerated"
            case .embeddedPDV: return "embeddedPDV"
            case .utf8String: return "utf8String"
            case .sequence: return "sequence"
            case .set: return "set"
            case .numericString: return "numericString"
            case .printableString: return "printableString"
            case .teletexString: return "teletexString"
            case .videoTextString: return "videoTextString"
            case .ia5String: return "ia5String"
            case .utcTime: return "utcTime"
            case .generalizedTime: return "generalizedTime"
            case .graphicString: return "graphicString"
            case .visibleString: return "visibleString"
            case .generalString: return "generalString"
            case .universalString: return "universalString"
            case .bitmapString: return "bitmapString"
            case .usesLongForm: return "usesLongForm"
            }
        }
    }
}

class ASN1Parser {
    let inBytes: Bytes
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    var parseLevel = 0

    var didStartDocument: (() -> ())?
    var didEndDocument: (() -> ())?
    var didStartContainerWithType: ((ASN1Type) -> ())?
    var didEndContainerWithType: ((ASN1Type) -> ())?
    var didStartContextWithType: ((ASN1Type) -> ())?
    var didEndContextWithType: ((ASN1Type) -> ())?

    var foundNull: (() -> ())?
    var foundDate: ((NSDate) -> ())?
    var foundObjectIdentifier: ((String) -> ())?
    var foundString: ((String) -> ())?
    var foundBytes: ((Bytes) -> ())?
    var foundBitString: ((ASN1BitString) -> ())?
    var foundInt: ((Int) -> ())?
    var foundBool: ((Bool) -> ())?

    init(bytes inBytes: Bytes) {
        self.inBytes = inBytes
    }

    func parse() throws {
        didStartDocument?()

        try parse(0..<inBytes.count)

        didEndDocument?()
    }

    func parse(_ range: CountableRange<Int>) throws {
        parseLevel += 1

        var currentLocation = range.lowerBound

        repeat {
            let tag = inBytes[currentLocation]
            currentLocation += 1

            var tagType = ASN1Type(rawValue: tag & 0x1f)
            if tagType == nil {
                throw ASN1Error("Unknown tag \(tag) encountered.")
            }

            let tagConstructed = (tag & 0x20) > 0
            let tagClass = tag >> 6

            if tagType == ASN1Type.usesLongForm {
                throw ASN1Error("Long form not implemented.")
            }

            let (length, octetsConsumed): (Int, Int) = try parseLength(at: currentLocation)

            currentLocation += octetsConsumed
            let newLocation = currentLocation + length

            let subRange = currentLocation..<newLocation
            let subRangeLength = newLocation - currentLocation

            if subRange.endIndex > range.upperBound {
                throw ASN1Error("Subrange end beyond end of current range.")
            }

            if tagClass == 2 {
                didStartContextWithType?(tagType!)

                if !tagConstructed {
                    tagType = ASN1Type.octetString
                }
            }

            if tagConstructed {
                didStartContainerWithType?(tagType!)

                if subRangeLength > 0 {
                    try parse(subRange)
                }

                didEndContainerWithType?(tagType!)
            } else {
                let typeBytes = Bytes(inBytes[subRange])
                try parse(type: tagType!, bytes: typeBytes)
            }

            if tagClass == 2 {
                didEndContextWithType?(tagType!)
            }

            currentLocation = newLocation
        } while currentLocation < range.upperBound

        parseLevel -= 1
    }

    func parse(type: ASN1Type, bytes: Bytes) throws {
        typeSwitch: switch type {

        case .boolean:
            let bool = try parseBool(bytes)
            foundBool?(bool)

        case .integer:
            if bytes.count <= 4 && foundInt != nil {
                foundInt!(parseInt(bytes))
            } else {
                foundBytes?(bytes)
            }

        case .bitString:
            let bitString = parseBitString(bytes)
            foundBitString?(bitString)

        case .octetString:
            foundBytes?(bytes)

        case .null:
            foundNull?()

        case .objectIdentifier:
            let oid = try parseObjectIdentifier(bytes)
            foundObjectIdentifier?(oid)

        case .teletexString, .graphicString, .printableString, .utf8String, .ia5String:
            let string = try parseString(bytes)
            foundString?(string)

        case .utcTime, .generalizedTime:
            let date = try parseDate(bytes)
            foundDate?(date)

        default:
            throw ASN1Error("Tag of type \(type) not implemented.")
        }
    }

    func parseInt(_ bytes: Bytes) -> Int {
        var int = 0
        for byte in bytes {
            int = (int << 8) + Int(byte)
        }
        return int
    }

    func parseBool(_ bytes: Bytes) throws -> Bool {
        if bytes.count == 1 {
            return bytes[0] != 0
        } else {
            throw ASN1Error("Illegal Boolean value length.")
        }
    }

    func parseString(_ bytes: Bytes) throws -> String {
        return try bytes |> Bytes.data |> UTF8.string
    }

    func parseBitString(_ bytes: Bytes) -> ASN1BitString {
        let unusedBits = Int(bytes[0])
        let data = Bytes(bytes[1..<bytes.count])
        return ASN1BitString(data: data, unusedBits: unusedBits)
    }

    func parseObjectIdentifier(_ bytes: Bytes) throws -> String {
        var indexes = [String]()
        var byteIndex = 0
        while byteIndex < bytes.count {
            if byteIndex == 0 {
                let byte = bytes[byteIndex]
                indexes.append("\(Int(byte / 40))")
                indexes.append("\(Int(byte % 40))")
            } else {
                var value = 0
                var more = false
                repeat {
                    let byte = bytes[byteIndex]
                    value = (value << 7) + Int(byte & 0x7f)
                    more = (byte & 0x80) != 0

                    if more {
                        byteIndex += 1
                        if byteIndex == bytes.count {
                            throw ASN1Error("Invalid object identifier with 'more' bit set on last octet.")
                        }
                    }
                } while(more)

                indexes.append("\(value)")
            }
            byteIndex += 1
        }
        return indexes.joined(separator: ".")
    }

    func parseDate(_ bytes: Bytes) throws -> NSDate {
        let string = try parseString(bytes)
        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            throw ASN1Error("Unable to encode string as date.")
        }
    }

    func parseLength(at location: Int) throws -> (length: Int, octetsConsumed: Int) {
        var length = 0
        var octetsConsumed = 0
        var currentLocation = location

        let byte = inBytes[currentLocation]
        currentLocation += 1
        octetsConsumed += 1

        if byte < 0x80 {
            length = Int(byte)
        } else if byte > 0x80 {
            let octetsInLength = Int(byte & 0x7f)
            let newLocation = currentLocation + octetsInLength
            let lengthOctets = inBytes[currentLocation..<newLocation]
            octetsConsumed += octetsInLength
            for octet in lengthOctets {
                length = (length << 8) + Int(octet)
            }
        } else {
            throw ASN1Error("Indefinite Length form encountered, not implemented.")
        }

        return (length, octetsConsumed)
    }
}
