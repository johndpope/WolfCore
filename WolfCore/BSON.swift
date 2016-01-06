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

public typealias BSONObject = Any
public typealias BSONDictionary = [String: Any?]
public typealias BSONArray = [Any?]


public func testBSON() {
    do {
        var dict = BSONDictionary()
        dict["hello"] = "world"
        let bson = try BSONDocument(dict: dict)
        print("bson: \(bson)")
    } catch(let error) {
        print("error: \(error)")
    }
    
    do {
        var array = BSONArray()
        array.append("awesome")
        array.append(5.05)
        array.append(Int32(1986))
        var dict = BSONDictionary()
        dict["BSON"] = array
        let bson = try BSONDocument(dict: dict)
        print("bson: \(bson)")
    } catch(let error) {
        print("error: \(error)")
    }
}

enum BSONBinarySubtype: Byte {
    case Generic = 0x00
    case Function = 0x01
    case UUID = 0x04
    case MD5 = 0x05
    case UserDefined = 0x80
}

enum BSONElementType: Byte {
    case EndOfObject = 0x00
    case Double = 0x01
    case String = 0x02
    case Document = 0x03
    case Array = 0x04
    case Binary = 0x05
    case ObjectID = 0x07
    case Boolean = 0x08
    case Datetime = 0x09
    case Null = 0x0a
    case Regex = 0x0b
    case JavaScript = 0x0d
    case JavaScriptWithScope = 0x0f
    case Int32 = 0x10
    case Timestamp = 0x11
    case Int = 0x12
    case MinKey = 0xff
    case MaxKey = 0x7f
}

public class BSONBuffer {
    private(set) var bytes = Bytes()
    var mark = 0

    init() {
        bytes.reserveCapacity(1000)
    }
}

extension BSONBuffer {
    func appendByte(byte: Byte) {
        bytes.append(byte)
    }
    
    func appendBytes(inBytes: Bytes) {
        bytes.appendContentsOf(inBytes)
    }
    
    func appendBytes(p: UnsafePointer<Byte>, count: Int) {
        for index in 0..<count {
            appendByte(p[index])
        }
    }
    
    func appendBytes(inBytes: ContiguousArray<Byte>) {
        bytes.appendContentsOf(inBytes)
    }
    
    func appendInt32(int: Int32) {
        var i = int.littleEndian
        withUnsafePointer(&i) {
            appendBytes(UnsafePointer<Byte>($0), count: sizeof(Int32))
        }
    }
    
    func appendInt(int: Int) {
        var i = int.littleEndian
        withUnsafePointer(&i) {
            appendBytes(UnsafePointer<Byte>($0), count: sizeof(Int))
        }
    }
    
    func appendDouble(double: Double) {
        var d = double
        withUnsafePointer(&d) {
            appendBytes(UnsafePointer<Byte>($0), count: sizeof(Double))
        }
    }
    
    func appendCString(string: String) {
        bytes.appendContentsOf(string.nulTerminatedUTF8)
    }
    
    func appendString(string: String) {
        let utf8 = string.nulTerminatedUTF8
        appendInt32(Int32(utf8.count))
        appendBytes(utf8)
    }
    
    func appendBuffer(buffer: BSONBuffer) {
        bytes.appendContentsOf(buffer.bytes)
    }
    
    func appendDocument(document: BSONDocument) {
        appendInt32(Int32(document.elementList.bytes.count + sizeof(Int32) + 1))
        appendBuffer(document.elementList)
        appendByte(0x00)
    }
}

extension BSONBuffer {
    func readBytes(count: Int) throws -> UnsafePointer<Byte> {
        guard mark + count < bytes.count else {
            throw GeneralError(message: "Needed \(count) bytes, but only \(bytes.count - mark) available.")
        }
        let m = mark
        mark += count
        withUnsafePointer(&bytes[m]) { p in
            return p
        }
        return nil
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
    
    private func decodeString(p: UnsafePointer<Byte>) throws -> String {
        let s = String.fromCString(UnsafePointer<CChar>(p))
        if let s = s {
            return s
        } else {
            throw GeneralError(message: "Could not decode UTF-8 string.")
        }
    }
    
    func readCString() throws -> String {
        var bytes = try readBytesUntilNul()
        return try decodeString(&bytes)
    }
    
    func readString() throws -> String {
        let count = Int(try readInt32())
        let p = try readBytes(count)
        return try decodeString(p)
    }
}

public class BSONDocument: BSONBuffer {
    let elementList = BSONElementList()

    public init(dict: BSONDictionary) throws {
        super.init()
        
        for (name, value) in dict {
            try elementList.appendElementWithName(name, value: value)
        }
        appendDocument(self)
    }
    
    public init(array: BSONArray) throws {
        super.init()
        
        for (index, value) in array.enumerate() {
            try elementList.appendElementWithName(String(index), value: value)
        }
        appendDocument(self)
    }
    
    public init(bytes: Bytes) {
        super.init()
        
        self.bytes = bytes
    }
}

extension BSONDocument {
//    public func parse() throws -> BSONObject {
//        
//    }
}

extension BSONDocument: CustomStringConvertible {
    public var description: String {
        var s = [String]()
        for byte in bytes {
            let t = String(byte, radix: 16, uppercase: false)
            s.append(t)
        }
        return "<BSONDocument \(s.joinWithSeparator(" "))>"
    }
}

class BSONElementList: BSONBuffer {
    func appendElementWithName(name: String, value: Any?) throws {
        if let value = value {
            switch value {
            case is Int:
                appendIntWithName(name, int: value as! Int)
            case is Int32:
                appendInt32WithName(name, int: value as! Int32)
            case is Bool:
                appendBooleanWithName(name, boolean: value as! Bool)
            case is String:
                appendStringWithName(name, string: value as! String)
            case is Bytes:
                appendBinaryWithName(name, bytes: value as! Bytes)
            case is Double:
                appendDoubleWithName(name, double: value as! Double)
            case is BSONDictionary:
                try appendDictionaryWithName(name, dict: value as! BSONDictionary)
            case is BSONArray:
                try appendArrayWithName(name, array: value as! BSONArray)
            default:
                throw GeneralError(message: "Could not encode BSON value \(value).")
            }
        } else {
            appendNullWithName(name)
        }
    }
    
    //
    // MARK: - Primitives
    //
    
    private func appendElementName(name: String) {
        appendCString(name)
    }
    
    private func appendBinarySubtype(subtype: BSONBinarySubtype) {
        appendByte(subtype.rawValue)
    }
    
    private func appendElementType(type: BSONElementType) {
        appendByte(type.rawValue)
    }
   
    //
    // MARK: - Elements
    //
    
    private func appendDoubleWithName(name: String, double: Double) {
        appendElementType(.Double)
        appendElementName(name)
        appendDouble(double)
    }
    
    private func appendStringWithName(name: String, string: String) {
        appendElementType(.String)
        appendElementName(name)
        appendString(string)
    }
    
    private func appendBinaryWithName(name: String, bytes: Bytes, subtype: BSONBinarySubtype = .UserDefined) {
        appendElementType(.Binary)
        appendElementName(name)
        appendInt32(Int32(bytes.count))
        appendBinarySubtype(subtype)
        appendBytes(bytes)
    }
    
    private func appendBooleanWithName(name: String, boolean: Bool) {
        appendElementType(.Boolean)
        appendElementName(name)
        appendByte(boolean ? 0x01 : 0x00)
    }
    
    private func appendUTCDatetimeWithName(name: String, datetime: Int) {
        appendElementType(.Datetime)
        appendElementName(name)
        appendInt(datetime)
    }
    
    private func appendNullWithName(name: String) {
        appendElementType(.Null)
        appendElementName(name)
    }
    
    private func appendRegexWithName(name: String, pattern: String, options: String) {
        appendElementType(.Regex)
        appendElementName(name)
        appendCString(pattern)
        appendCString(options)
    }
    
    private func appendJavaScriptWithName(name: String, javaScript: String) {
        appendElementType(.JavaScript)
        appendElementName(name)
        appendString(javaScript)
    }
    
    private func appendInt32WithName(name: String, int: Int32) {
        appendElementType(.Int32)
        appendElementName(name)
        appendInt32(int)
    }
    
    private func appendIntWithName(name: String, int: Int) {
        appendElementType(.Int)
        appendElementName(name)
        appendInt(int)
    }
    
    private func appendDictionaryWithName(name: String, dict: BSONDictionary) throws {
        let document = try BSONDocument(dict: dict)
        appendElementType(.Document)
        appendElementName(name)
        appendDocument(document)
    }
    
    private func appendArrayWithName(name: String, array: BSONArray) throws {
        let arr = try BSONDocument(array: array)
        appendElementType(.Array)
        appendElementName(name)
        appendDocument(arr)
    }
}
