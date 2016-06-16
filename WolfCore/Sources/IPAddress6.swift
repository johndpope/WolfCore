//
//  IPAddress6.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class IPAddress6 {
    typealias Run = Range<Int>

    private static func replace(longestRun: Run?, wordsCount: Int, components: inout [String]) {
        if let longestRun = longestRun {
            let replacement: [String]
            // all zeroes
            if longestRun.lowerBound == 0 && longestRun.upperBound == wordsCount {
                replacement = ["", "", ""]
                // zeroes at beginning or end
            } else if longestRun.lowerBound == 0 || longestRun.upperBound == wordsCount {
                replacement = ["", ""]
                // zeroes somewhere in the middle
            } else {
                replacement = [""]
            }
            components.replaceSubrange(longestRun, with: replacement)
        }
    }

    public static func encode(_ words: [UInt16], padWithZeroes: Bool = false, collapseLongestZeroRun: Bool = true) -> String {
        assert(words.count == 8)

        var longestRun: Run? = nil
        if collapseLongestZeroRun {
            var currentRun: Run? = nil
            for (index, word) in words.enumerated() {
                // print("index: \(index), word: \(word)")
                if word == 0 {
                    if currentRun == nil {
                        currentRun = index..<index
                        // print("started currentRun: \(currentRun!)")
                    }
                }

                if currentRun != nil {
                    if word == 0 {
                        if longestRun == nil {
                            longestRun = currentRun
                            // print("started longestRun: \(longestRun!)")
                        }

                        // print("currentRun: \(currentRun!), longestRun: \(longestRun!)")
                        currentRun = currentRun!.lowerBound ..< currentRun!.upperBound + 1
                        // print("extended currentRun: \(currentRun!)")

                        let currentLength = currentRun!.upperBound - currentRun!.lowerBound
                        let longestLength = longestRun!.upperBound - longestRun!.lowerBound
                        if currentLength > longestLength {
                            longestRun = currentRun
                            // print("replaced longestRun: \(longestRun!)")
                        }
                    } else {
                        currentRun = nil
                        // print("ended currentRun")
                    }
                }
            }
        }
        // print("longestRun: \(longestRun)")

        var components = [String]()
        for word in words {
            var component = String(word, radix: 16)
            if padWithZeroes {
                component = component.padded(toCount: 4, withCharacter: "0")
            }
            components.append(component)
        }

        replace(longestRun: longestRun, wordsCount: words.count, components: &components)

        return components.joined(separator: ":")
    }

    private static func toWords(_ bytes: Bytes) -> [UInt16] {
        assert(bytes.count == 16)
        var words = [UInt16]()
        words.reserveCapacity(8)
        bytes.withUnsafeBufferPointer {p in
            let p16 = UnsafePointer<UInt16>(p.baseAddress)!
            for index in 0..<8 {
                words.append(UInt16(bigEndian: p16[index]))
            }
        }
        return words
    }

    private static func toBytes(_ words: [UInt16]) -> Bytes {
        assert(words.count == 8)
        var bytes = Bytes()
        bytes.reserveCapacity(16)
        for word in words {
            var bigWord = word.bigEndian
            withUnsafePointer(&bigWord) { p in
                let p8 = UnsafePointer<Byte>(p)
                bytes.append(p8[0])
                bytes.append(p8[1])
            }
        }
        return bytes
    }

    public static func encode(_ bytes: Bytes, padWithZeroes: Bool = false, collapseLongestZeroRun: Bool = true) -> String {
        return encode(toWords(bytes), padWithZeroes: padWithZeroes, collapseLongestZeroRun: collapseLongestZeroRun)
    }

    public static func decode(_ string: String) throws -> [UInt16] {
        var components = string.components(separatedBy: ":")
        guard components.count >= 3 else {
            throw ValidationError(message: "Invalid IP address.", violation: "ipv6Format")
        }
//        print(components)
        if components == ["", "", ""] {
            components = ["#"]
        } else if components.prefix(2) == ["", ""] {
            components = Array(components.dropFirst(2))
            components.insert("#", at: 0)
        } else if components.suffix(2) == ["", ""] {
            components = Array(components.dropLast(2))
            components.append("#")
        } else if let index = components.index(of: "") {
            guard index != 0 && index != components.endIndex - 1 else {
                throw ValidationError(message: "Invalid IP address.", violation: "ipv6Format")
            }
            components.replaceSubrange(index...index, with: ["#"])
        }
//        print(components)

        if let index = components.index(of: "#") {
            let count = 9 - components.count
            let zeros = [String](repeating: "0", count: count)
            components.replaceSubrange(index...index, with: zeros)
        }
//        print(components)
        guard components.count == 8 else {
            throw ValidationError(message: "Invalid IP address.", violation: "ipv6Format")
        }

        var words = [UInt16]()
        words.reserveCapacity(8)
        for component in components {
            guard let i = UInt16(component, radix: 16) else {
                throw ValidationError(message: "Invalid IP address.", violation: "ipv6Format")
            }
            words.append(i)
        }

//        print("words: \(words)")

        return words
    }

    public static func decode(string: String) throws -> Bytes {
        return toBytes(try decode(string))
    }

    public static func test() {
        test([0x0, 0x0, 0x1, 0x0, 0xfffe, 0x0, 0x0, 0x1234],
            encodedLong: "0000:0000:0001:0000:fffe:0000:0000:1234",
            encodedShort: "::1:0:fffe:0:0:1234")

        test([0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0],
            encodedLong: "0000:0000:0000:0000:0000:0000:0000:0000",
            encodedShort: "::")

        test([0x1, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x3],
            encodedLong: "0001:0000:0000:0002:0000:0000:0000:0003",
            encodedShort: "1:0:0:2::3")

        test([0x1, 0x0, 0x0, 0x2, 0x3, 0x0, 0x0, 0x0],
            encodedLong: "0001:0000:0000:0002:0003:0000:0000:0000",
            encodedShort: "1:0:0:2:3::")

        do {
            print(try [UInt16](IPAddress6.decode("::f:a:1")))
            print(IPAddress6.encode([UInt16]([0, 0, 0, 0, 0, 2, 3, 1])))
        } catch let error {
            logError(error)
        }
    }

    public static func test(_ words: [UInt16], encodedLong: String, encodedShort: String) {
        do {
            logInfo("words: \(words), encodedLong: \(encodedLong), encodedShort: \(encodedShort)")

            let encoded1 = IPAddress6.encode(words, padWithZeroes: true, collapseLongestZeroRun: false)
            assert(encoded1 == encodedLong)
            let encoded2 = IPAddress6.encode(words)
            assert(encoded2 == encodedShort)

            let bytes = toBytes(words)
            let encoded3 = IPAddress6.encode(bytes, padWithZeroes: true, collapseLongestZeroRun: false)
            assert(encoded3 == encoded1)

            let decodeWords: [UInt16] = try IPAddress6.decode(encoded2)
            assert(decodeWords == words)

            logInfo("Passed.")
        } catch let error {
            logError(error)
        }
    }
}
