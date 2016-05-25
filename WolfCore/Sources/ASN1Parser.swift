//
//  ASN1Parser.swift
//  WolfCore
//
//  Created by Robert McNally on 1/22/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public struct ASN1Error: Error, CustomStringConvertible {
    public let message: String
    public let code: Int

    public init(_ message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }

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
                let c: Character = bitAtIndex(bitIndex) ? "1" : "0"
                s.append(c)
            }
            return s
        }
    }

    func bitAtIndex(bitIndex: Int) -> Bool {
        assert(bitIndex >= 0 && bitIndex < numberOfBits)

        let byteIndex = bitIndex / 8
        let bitIndexInByte = 7 - bitIndex % 8
        let bit = data[byteIndex] & UInt8(1 << bitIndexInByte)
        return bit != 0
    }
}

enum ASN1Type: UInt8, CustomStringConvertible {
    case EOC = 0x00
    case Boolean = 0x01
    case Integer = 0x02
    case BitString = 0x03
    case OctetString = 0x04
    case Null = 0x05
    case ObjectIdentifier = 0x06
    case ObjectDescriptor = 0x07
    case External = 0x08
    case Real = 0x09
    case Enumerated = 0x0a
    case EmbeddedPDV = 0x0b
    case UTF8String = 0x0c
    case Sequence = 0x10
    case Set = 0x11
    case NumericString = 0x12
    case PrintableString = 0x13
    case TeletexString = 0x14
    case VideoTextString = 0x15
    case IA5String = 0x16
    case UTCTime = 0x17
    case GeneralizedTime = 0x18
    case GraphicString = 0x19
    case VisibleString = 0x1a
    case GeneralString = 0x1b
    case UniversalString = 0x1c
    case BitmapString = 0x1e
    case UsesLongForm = 0x1f

    var description: String {
        get {
            switch self {
            case .EOC: return "EOC"
            case .Boolean: return "Boolean"
            case .Integer: return "Integer"
            case .BitString: return "BitString"
            case .OctetString: return "OctetString"
            case .Null: return "Null"
            case .ObjectIdentifier: return "ObjectIdentifier"
            case .ObjectDescriptor: return "ObjectDescriptor"
            case .External: return "External"
            case .Real: return "Real"
            case .Enumerated: return "Enumerated"
            case .EmbeddedPDV: return "EmbeddedPDV"
            case .UTF8String: return "UTF8String"
            case .Sequence: return "Sequence"
            case .Set: return "Set"
            case .NumericString: return "NumericString"
            case .PrintableString: return "PrintableString"
            case .TeletexString: return "TeletexString"
            case .VideoTextString: return "VideoTextString"
            case .IA5String: return "IA5String"
            case .UTCTime: return "UTCTime"
            case .GeneralizedTime: return "GeneralizedTime"
            case .GraphicString: return "GraphicString"
            case .VisibleString: return "VisibleString"
            case .GeneralString: return "GeneralString"
            case .UniversalString: return "UniversalString"
            case .BitmapString: return "BitmapString"
            case .UsesLongForm: return "UsesLongForm"
            }
        }
    }
}

class ASN1Parser {
    let inBytes: Bytes
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyMMddHHmmss'Z'"
        formatter.timeZone = NSTimeZone(abbreviation: "UTC")
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

    func parse(range: Range<Int>) throws {
        parseLevel += 1

        var currentLocation = range.startIndex

        repeat {
            let tag = inBytes[currentLocation]
            currentLocation += 1

            var tagType = ASN1Type(rawValue: tag & 0x1f)
            if tagType == nil {
                throw ASN1Error("Unknown tag \(tag) encountered.")
            }

            let tagConstructed = (tag & 0x20) > 0
            let tagClass = tag >> 6

            if tagType == ASN1Type.UsesLongForm {
                throw ASN1Error("Long form not implemented.")
            }

            let (length, octetsConsumed): (Int, Int) = try parseLengthAtLocation(currentLocation)

            currentLocation += octetsConsumed
            let newLocation = currentLocation + length

            let subRange = currentLocation..<newLocation
            let subRangeLength = newLocation - currentLocation

            if subRange.endIndex > range.endIndex {
                throw ASN1Error("Subrange end beyond end of current range.")
            }

            if tagClass == 2 {
                didStartContextWithType?(tagType!)

                if !tagConstructed {
                    tagType = ASN1Type.OctetString
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
                try parse(tagType!, bytes: typeBytes)
            }

            if tagClass == 2 {
                didEndContextWithType?(tagType!)
            }

            currentLocation = newLocation
        } while currentLocation < range.endIndex

        parseLevel -= 1
    }

    func parse(type: ASN1Type, bytes: Bytes) throws {
        typeSwitch: switch type {

        case .Boolean:
            let bool = try parseBool(bytes)
            foundBool?(bool)

        case .Integer:
            if bytes.count <= 4 && foundInt != nil {
                foundInt!(parseInt(bytes))
            } else {
                foundBytes?(bytes)
            }

        case .BitString:
            let bitString = parseBitString(bytes)
            foundBitString?(bitString)

        case .OctetString:
            foundBytes?(bytes)

        case .Null:
            foundNull?()

        case .ObjectIdentifier:
            let oid = try parseObjectIdentifier(bytes)
            foundObjectIdentifier?(oid)

        case .TeletexString, .GraphicString, .PrintableString, .UTF8String, .IA5String:
            let string = try parseString(bytes)
            foundString?(string)

        case .UTCTime, .GeneralizedTime:
            let date = try parseDate(bytes)
            foundDate?(date)

        default:
            throw ASN1Error("Tag of type \(type) not implemented.")
        }
    }

    func parseInt(bytes: Bytes) -> Int {
        var int = 0
        for byte in bytes {
            int = (int << 8) + Int(byte)
        }
        return int
    }

    func parseBool(bytes: Bytes) throws -> Bool {
        if bytes.count == 1 {
            return bytes[0] != 0
        } else {
            throw ASN1Error("Illegal Boolean value length.")
        }
    }

    func parseString(bytes: Bytes) throws -> String {
        return try UTF8.decode(bytes)
    }

    func parseBitString(bytes: Bytes) -> ASN1BitString {
        let unusedBits = Int(bytes[0])
        let data = Bytes(bytes[1..<bytes.count])
        return ASN1BitString(data: data, unusedBits: unusedBits)
    }

    func parseObjectIdentifier(bytes: Bytes) throws -> String {
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
        return indexes.joinWithSeparator(".")
    }

    func parseDate(bytes: Bytes) throws -> NSDate {
        let string = try parseString(bytes)
        if let date = dateFormatter.dateFromString(string) {
            return date
        } else {
            throw ASN1Error("Unable to encode string as date.")
        }
    }

    func parseLengthAtLocation(location: Int) throws -> (length: Int, octetsConsumed: Int) {
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
