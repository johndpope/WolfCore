//
//  BSON.swift
//  WolfCore
//
//  Created by Robert McNally on 1/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

//
// http://bsonspec.org/spec.html
//

import Foundation

public typealias BSONValue = Any?
public typealias BSONDictionary = [String: BSONValue]
public typealias BSONArray = [BSONValue]


public struct BSON {
    public static func data(_ dict: BSONDictionary) throws -> Data {
        return try dict |> BSON.bytes |> Bytes.data
    }

    public static func bytes(_ dict: BSONDictionary) throws -> Bytes {
        return try dict |> BSON.doc |> BSON.bytes
    }
}

extension Data {
    public static func bson(_ data: Data) throws -> BSONDictionary {
        return try data |> BSON.doc |> BSON.bson
    }
}

extension BSON {
    private static func doc(dict: BSONDictionary) throws -> BSONDocument {
        return try BSONDocument(dict: dict)
    }

    private static func doc(data: Data) -> BSONDocument {
        return BSONDocument(data: data)
    }

    private static func bytes(doc: BSONDocument) -> Bytes {
        return doc.bytes
    }

    private static func bson(doc: BSONDocument) throws -> BSONDictionary {
        return try doc.decode()
    }
}

public struct BSONError: Error {
    public let message: String
    public let code: Int

    public init(message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }

    public var identifier: String {
        return "BSONError(\(code))"
    }
}

extension BSONError: CustomStringConvertible {
    public var description: String {
        return "BSONError(\(message))"
    }
}


public func testBSON() {
    do {
        var greetingsDict = BSONDictionary()
        greetingsDict["hello"] = "world"
        greetingsDict.updateValue(nil, forKey: "goodbye")
        testBSON(greetingsDict)
    }

    do {
        var greetingsDict = BSONDictionary()
        greetingsDict["hello"] = "world"
        greetingsDict.updateValue(nil, forKey: "goodbye")

        var personDict = BSONDictionary()
        personDict["firstName"] = "Robert"
        personDict["lastName"] = "McNally"
        personDict["greetings"] = greetingsDict

        var array = BSONArray()
        array.append("awesome")
        array.append(nil)
        array.append(5.05)
        array.append(personDict)
        array.append(Int32(1986))
        var dict = BSONDictionary()
        dict["BSON"] = array
        testBSON(dict)
    }
}

private func testBSON(_ encodeDict: BSONDictionary) {
    do {
        print("encodeDict: \(encodeDict)")
        print(bsonDict: encodeDict)
        let bson = try BSONDocument(dict: encodeDict)
        print("bson: \(bson)")
        let decodeDict = try bson.decode()
        print("decodeDict:")
        print(bsonDict: decodeDict)
        let bson2 = try BSONDocument(dict: decodeDict)
        print("bson2: \(bson2)")
    } catch let error {
        print("error: \(error)")
    }
}


enum BSONBinarySubtype: Byte {
    case generic = 0x00
    case function = 0x01
    case uuid = 0x04
    case md5 = 0x05
    case userDefined = 0x80
}

enum BSONElementType: Byte {
    case endOfObject = 0x00
    case double = 0x01
    case string = 0x02
    case document = 0x03
    case array = 0x04
    case binary = 0x05
    case objectID = 0x07
    case boolean = 0x08
    case dateTime = 0x09
    case null = 0x0a
    case regex = 0x0b
    case javaScript = 0x0d
    case javaScriptWithScope = 0x0f
    case int32 = 0x10
    case timestamp = 0x11
    case int = 0x12
    case minKey = 0xff
    case maxKey = 0x7f
}

public class BSONBuffer {
    private(set) var bytes: Bytes
    var mark = 0

    init() {
        bytes = Bytes()
        bytes.reserveCapacity(1000)
    }

    init(bytes: Bytes, mark: Int = 0) {
        self.bytes = bytes
        self.mark = 0
    }
}

extension BSONBuffer {
    func append(byte: Byte) {
        bytes.append(byte)
    }

    func append(bytes inBytes: Bytes) {
        bytes.append(contentsOf: inBytes)
    }

    func append(bytes p: UnsafePointer<Byte>, count: Int) {
        for index in 0..<count {
            append(byte: p[index])
        }
    }

    func append(bytes inBytes: ContiguousArray<Byte>) {
        bytes.append(contentsOf: inBytes)
    }

    func append(int32: Int32) {
        var i = int32.littleEndian
        withUnsafePointer(&i) {
            append(bytes: UnsafePointer<Byte>($0), count: sizeof(Int32))
        }
    }

    func append(int: Int) {
        var i = int.littleEndian
        withUnsafePointer(&i) {
            append(bytes: UnsafePointer<Byte>($0), count: sizeof(Int))
        }
    }

    func append(double: Double) {
        var d = double
        withUnsafePointer(&d) {
            append(bytes: UnsafePointer<Byte>($0), count: sizeof(Double))
        }
    }

    func append(cString: String) {
        bytes.append(contentsOf: cString.nulTerminatedUTF8)
    }

    func append(string: String) {
        let utf8 = string.nulTerminatedUTF8
        append(int32: Int32(utf8.count))
        append(bytes: utf8)
    }

    func append(buffer: BSONBuffer) {
        bytes.append(contentsOf: buffer.bytes)
    }

    func append(document: BSONDocument) {
        append(int32: Int32(document.elementList.bytes.count + sizeof(Int32) + 1))
        append(buffer: document.elementList)
        append(byte: 0x00)
    }
}

extension BSONBuffer {
    func readBytes(_ count: Int) throws -> UnsafePointer<Byte> {
        let available = bytes.count - mark
        guard available >= count else {
            throw BSONError(message: "Needed \(count) bytes, but only \(available) available.")
        }
        let p = withUnsafePointer(&bytes[mark]) { $0 }
        mark += count
        return p
    }

    func readByte() throws -> Byte {
        let p = try readBytes(1)
        return p[0]
    }

    func readBytesUntilNul() throws -> Bytes {
        var bytes = Bytes()
        while true {
            let byte = try readByte()
            bytes.append(byte)
            if byte == 0x00 {
                break
            }
        }
        return bytes
    }

    func readInt32() throws -> Int32 {
        let p = try readBytes(sizeof(Int32))
        let i = UnsafePointer<Int32>(p)[0]
        return Int32(littleEndian: i)
    }

    func readInt() throws -> Int {
        let p = try readBytes(sizeof(Int))
        let i = UnsafePointer<Int>(p)[0]
        return Int(littleEndian: i)
    }

    func readDouble() throws -> Double {
        let p = try readBytes(sizeof(Double))
        return UnsafePointer<Double>(p)[0]
    }

    func readBoolean() throws -> Bool {
        let b = try readByte()
        switch b {
        case 0x00:
            return false
        case 0x01:
            return true
        default:
            throw BSONError(message: "Expected Boolean value 0 or 1, got: \(b)")
        }
    }

    private func decodeString(fromBytes p: UnsafePointer<Byte>) throws -> String {
        let s = String(validatingUTF8: UnsafePointer<CChar>(p))
        if let s = s {
            return s
        } else {
            throw BSONError(message: "Could not decode UTF-8 string.")
        }
    }

    func readCString() throws -> String {
        var bytes = try readBytesUntilNul()
        return try decodeString(fromBytes: &bytes)
    }

    func readElementName() throws -> String {
        return try readCString()
    }

    func readString() throws -> String {
        let count = Int(try readInt32())
        let p = try readBytes(count)
        return try decodeString(fromBytes: p)
    }

    func readBinary() throws -> Any {
        let count = Int(try readInt32())
        let rawSubtype = try readByte()
        let bytes = try readBytes(count)
        if let subtype = BSONBinarySubtype(rawValue: rawSubtype) {
            switch subtype {
            case .userDefined:
                return bytes
            default:
                throw BSONError(message: "Unsupported binary subtype: \(subtype).")
            }
        } else {
            throw BSONError(message: "Unknown binary subtype: \(rawSubtype).")
        }
    }

    // swiftlint:disable cyclomatic_complexity

    func readElement() throws -> (name: String, value: BSONValue)? {
        let rawElementType = try readByte()
        guard let elementType = BSONElementType(rawValue: rawElementType) else {
            throw BSONError(message: "Unknown element type: \(rawElementType).")
        }
        guard elementType != .endOfObject else {
            return nil
        }
        let name = try readElementName()
        let value: BSONValue
        switch elementType {
        case .int:
            value = try readInt()
        case .int32:
            value = try readInt32()
        case .boolean:
            value = try readBoolean()
        case .string:
            value = try readString()
        case .binary:
            value = try readBinary()
        case .double:
            value = try readDouble()
        case .document:
            _ = try readInt32() // throw away size of embedded document
            value = try readDocument()
        case .array:
            _ = try readInt32() // throw away size of embedded array
            value = try readArray()
        case .null:
            value = nil
        default:
            throw BSONError(message: "Unsupported element type: \(elementType).")
        }
        return (name, value)
    }

    // swiftlint:enable cyclomatic_complexity

    func readDocument() throws -> BSONDictionary {
        var dict = BSONDictionary()
        while true {
            if let result = try readElement() {
                let name = result.name
                let value = result.value
                dict[name] = value
            } else {
                break
            }
        }
        return dict
    }

    func readArray() throws -> BSONArray {
        var array = BSONArray()
        while true {
            if let result = try readElement() {
                array.append(result.value)
            } else {
                break
            }
        }
        return array
    }
}

public class BSONDocument: BSONBuffer {
    let elementList = BSONElementList()

    public init(dict: BSONDictionary) throws {
        super.init()

        for (name, value) in dict {
            try elementList.appendElement(withName: name, value: value)
        }
        append(document: self)
    }

    public init(array: BSONArray) throws {
        super.init()

        for (index, value) in array.enumerated() {
            try elementList.appendElement(withName: String(index), value: value)
        }
        append(document: self)
    }

    public init(bytes: Bytes) {
        super.init()

        self.bytes = bytes
    }

    public convenience init(data: Data) {
        self.init(bytes: data |> Data.bytes)
    }
}

extension BSONDocument {
    public func decode() throws -> BSONDictionary {
        mark = 0
        let size = Int(try readInt32())
        if size != bytes.count {
            throw BSONError(message: "Expected buffer of size: \(size), got: \(bytes.count)")
        }
        return try readDocument()
    }
}

extension BSONDocument: CustomStringConvertible {
    public var description: String {
        let s = bytes |> Bytes.hex
        return "<BSONDocument \(s))>"
    }
}

class BSONElementList: BSONBuffer {
    func appendElement(withName name: String, value: Any?) throws {
        if let value = value {
            switch value {
            case is Int:
                append(int: value as! Int, withName: name)
            case is Int32:
                append(int32: value as! Int32, withName: name)
            case is Bool:
                append(boolean: value as! Bool, withName: name)
            case is String:
                append(string: value as! String, withName: name)
            case is Bytes:
                append(binary: value as! Bytes, withName: name)
            case is Double:
                append(double: value as! Double, withName: name)
            case is BSONDictionary:
                try append(dictionary: value as! BSONDictionary, withName: name)
            case is BSONArray:
                try append(array: value as! BSONArray, withName: name)
            default:
                throw BSONError(message: "Could not encode value \(value).")
            }
        } else {
            appendNull(withName: name)
        }
    }

    //
    // MARK: - Primitives
    //

    private func append(elementName name: String) {
        append(cString: name)
    }

    private func append(binarySubtype subtype: BSONBinarySubtype) {
        append(byte: subtype.rawValue)
    }

    private func append(elementType type: BSONElementType) {
        append(byte: type.rawValue)
    }

    //
    // MARK: - Elements
    //

    private func append(double: Double, withName name: String) {
        append(elementType: .double)
        append(elementName: name)
        append(double: double)
    }

    private func append(string: String, withName name: String) {
        append(elementType: .string)
        append(elementName: name)
        append(string: string)
    }

    private func append(binary bytes: Bytes, withName name: String, subtype: BSONBinarySubtype = .userDefined) {
        append(elementType: .binary)
        append(elementName: name)
        append(int32: Int32(bytes.count))
        append(binarySubtype: subtype)
        append(bytes: bytes)
    }

    private func append(boolean: Bool, withName name: String) {
        append(elementType: .boolean)
        append(elementName: name)
        append(byte: boolean ? 0x01 : 0x00)
    }

    private func append(utcDateTime datetime: Int, withName name: String) {
        append(elementType: .dateTime)
        append(elementName: name)
        append(int: datetime)
    }

    private func appendNull(withName name: String) {
        append(elementType: .null)
        append(elementName: name)
    }

    private func append(regex pattern: String, options: String, withName name: String) {
        append(elementType: .regex)
        append(elementName: name)
        append(cString: pattern)
        append(cString: options)
    }

    private func append(javaScript: String, withName name: String) {
        append(elementType: .javaScript)
        append(elementName: name)
        append(string: javaScript)
    }

    private func append(int32 int: Int32, withName name: String) {
        append(elementType: .int32)
        append(elementName: name)
        append(int32: int)
    }

    private func append(int: Int, withName name: String) {
        append(elementType: .int)
        append(elementName: name)
        append(int: int)
    }

    private func append(dictionary dict: BSONDictionary, withName name: String) throws {
        let document = try BSONDocument(dict: dict)
        append(elementType: .document)
        append(elementName: name)
        append(document: document)
    }

    private func append(array: BSONArray, withName name: String) throws {
        let arr = try BSONDocument(array: array)
        append(elementType: .array)
        append(elementName: name)
        append(document: arr)
    }
}

public func print(bsonDict dict: BSONDictionary, indent: String = "", level: Int = 0) {
    for name in dict.keys {
        printBSONElement(withName: name, value: dict[name]!, indent: indent, level: level)
    }
}

private func print(bsonArray array: BSONArray, indent: String = "", level: Int = 0) {
    for (index, value) in array.enumerated() {
        printBSONElement(withName: String(index), value: value, indent: indent, level: level)
    }
}

// swiftlint:disable cyclomatic_complexity

private func printBSONElement(withName name: String, value: BSONValue, indent: String, level: Int) {
    let type: String
    let valueStr: String
    let pfx = "✅  "
    let err = "🚫  "
    if let value = value {
        switch value {
        case let int as Int:
            type = "\(pfx) Int"
            valueStr = "\(int)"
        case let int as Int32:
            type = "\(pfx) Int32"
            valueStr = "\(int)"
        case let s as String:
            type = "\(pfx) String"
            valueStr = "\"\(s)\""
        case let d as Double:
            type = "\(pfx) Double"
            valueStr = "\(d)"
        case is BSONDictionary:
            type = "\(pfx) Document"
            valueStr = ""
        case is BSONArray:
            type = "\(pfx) Array"
            valueStr = ""
        case let b as Bool:
            type = "\(pfx) Boolean"
            valueStr = "\(b)"
        case let b as Bytes:
            type = "\(pfx) Binary"
            valueStr = b |> Bytes.hex
        default:
            type = "\(err) UNKNOWN"
            valueStr = "\(value)"
        }
    } else {
        type = "nil"
        valueStr = ""
    }
    print("\(indent)\(name): \(type) \(valueStr)")
    if let value = value {
        let nextLevel = level + 1
        let nextIndent = "\t" + indent
        switch value {
        case let dict as BSONDictionary:
            print(bsonDict: dict, indent: nextIndent, level: nextLevel)
        case let array as BSONArray:
            print(bsonArray: array, indent: nextIndent, level: nextLevel)
        default:
            break
        }
    }
}

// swiftlint:enable cyclomatic_complexity
