//
//  IPAddress6.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class IPAddress6 {
    public static func encode(words: [UInt16], padWithZeroes: Bool = false, collapseLongestZeroRun: Bool = true) -> String {
        assert(words.count == 8)

        typealias Run = Range<Int>
        var longestRun: Run? = nil
        if collapseLongestZeroRun {
            var currentRun: Run? = nil
            for (index, word) in words.enumerate() {
                // print("index: \(index), word: \(word)")
                if word == 0 {
                    if currentRun == nil {
                        currentRun = Run(start: index, end: index)
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
                        currentRun = Run(start: currentRun!.startIndex, end: currentRun!.endIndex + 1)
                        // print("extended currentRun: \(currentRun!)")

                        let currentLength = currentRun!.endIndex - currentRun!.startIndex
                        let longestLength = longestRun!.endIndex - longestRun!.startIndex
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
                component = component.paddedToCount(4, withCharacter: "0")
            }
            components.append(component)
        }

        if let longestRun = longestRun {
            let replacement: [String]
            // all zeroes
            if longestRun.startIndex == 0 && longestRun.endIndex == words.count {
                replacement = ["", "", ""]
            // zeroes at beginning or end
            } else if longestRun.startIndex == 0 || longestRun.endIndex == words.count {
                replacement = ["", ""]
            // zeroes somewhere in the middle
            } else {
                replacement = [""]
            }
            components.replaceRange(longestRun, with: replacement)
        }

        return components.joinWithSeparator(":")
    }

    public static func encode(bytes: Bytes, padWithZeroes: Bool = false, collapseLongestZeroRun: Bool = true) -> String {
        assert(bytes.count == 16)
        return ""
    }

    public static func test() {
        // let words: [UInt16] = [0x0, 0x0, 0x5, 0xffff, 0x12e, 0x0, 0x0, 0x0]
        let words: [UInt16] = [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0]
        print(words)
        print(IPAddress6.encode(words, padWithZeroes: true, collapseLongestZeroRun: false))
        print(IPAddress6.encode(words))
    }
}
