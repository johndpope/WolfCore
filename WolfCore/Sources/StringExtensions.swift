//
//  StringExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/13/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

#if os(iOS) || os(OSX) || os(tvOS)
    import CoreGraphics
#endif

public typealias StringIndex = String.Index
public typealias StringRange = Range<StringIndex>

// Provide concise versions of NSLocalizedString.

#if os(iOS) || os(OSX) || os(tvOS)
    postfix operator ¶ { }

    public postfix func ¶ (left: String) -> String {
        return left.localized()
    }

    infix operator ¶ { associativity left precedence 95 }

    public func ¶ (left: String, right: [String : Any]) -> String {
        return left.localized(replacingPlaceholdersWithReplacements: right)
    }

    public func ¶ (left: String, right: AnyClass) -> String {
        return left.localized(inBundleForClass: right)
    }

    public func ¶ (left: String, right: (aClass: AnyClass, replacements: [String: Any])) -> String {
        return left.localized(inBundleForClass: right.aClass, replacingPlaceholdersWithReplacements: right.replacements)
    }
#endif

#if os(iOS) || os(OSX) || os(tvOS)
    extension String {
        public func localized(onlyIfTagged mustHaveTag: Bool = false, inBundleForClass aClass: AnyClass? = nil, inLanguage language: String? = nil, replacingPlaceholdersWithReplacements replacements: [String : Any]? = nil) -> String {

            let untaggedKey: String
            let taggedKey: String
            let hasTag: Bool
            if self.hasSuffix("¶") {
                untaggedKey = substringToIndex(self.endIndex.predecessor())
                taggedKey = self
                hasTag = true
            } else {
                untaggedKey = self
                taggedKey = self + "¶"
                hasTag = false
            }

            guard !mustHaveTag || hasTag else { return self }

            var bundle = NSBundle.findBundle(forClass: aClass)
            if let language = language {
                if let path = bundle.pathForResource(language, ofType: "lproj") {
                    if let langBundle = NSBundle(path: path) {
                        bundle = langBundle
                    }
                }
            }
            var localized = bundle.localizedStringForKey(taggedKey, value: nil, table: nil)
            if localized == taggedKey {
                localized = NSBundle.findBundle(forClass: BundleClass.self).localizedStringForKey(taggedKey, value: nil, table: nil)
            }
            if localized == taggedKey {
                logWarning("No localization found for: \"\(taggedKey)\".")
                localized = untaggedKey
            }
            if let replacements = replacements {
                localized = localized.replacing(placeholdersWithReplacements: replacements)
            }
            return localized
        }
    }
#endif

extension String {
    public func range(fromNSRange nsRange: NSRange?) -> StringRange? {
        guard let nsRange = nsRange else { return nil }
        let utf16view = utf16
        let from16 = utf16view.startIndex.advancedBy(nsRange.location, limit: utf16view.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16view.endIndex)
        if let from = StringIndex(from16, within: self),
            let to = StringIndex(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    public func nsRange(fromRange range: StringRange?) -> NSRange? {
        guard let range = range else { return nil }
        let utf16view = utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSRange(location: utf16view.startIndex.distanceTo(from), length: from.distanceTo(to))
    }

    public func location(fromIndex index: StringIndex) -> Int {
        return nsRange(fromRange: index..<index)!.location
    }

    public func index(fromLocation location: Int) -> StringIndex {
        return range(fromNSRange: NSRange(location: location, length: 0))!.startIndex
    }

    public var nsRange: NSRange {
        return nsRange(fromRange: range)!
    }

    public var range: StringRange {
        return startIndex..<endIndex
    }

    public func range(start start: Int, end: Int? = nil) -> StringRange {
        let s = startIndex.advancedBy(start)
        let e = startIndex.advancedBy(end ?? start)
        return s..<e
    }
}

extension String {
    public func replacing(ranges ranges: [StringRange], withReplacements replacements: [String]) -> (string: String, ranges: [StringRange]) {
        var mutatedSelf = self
        var replacedRanges = [StringRange]()

        var cumOffset = 0
        for (index, range) in ranges.enumerate() {
            let replacement = replacements[index]
            let replacementCount = replacement.characters.count
            let rangeCount = range.count
            let offset = replacementCount - rangeCount
            let startIndex = range.startIndex.advancedBy(cumOffset)
            let replacementRange = startIndex..<startIndex.advancedBy(rangeCount)
            mutatedSelf.replaceRange(replacementRange, with: replacement)
            for i in 0..<replacedRanges.count {
                let r = replacedRanges[i]
                if r.startIndex >= range.startIndex {
                    let adjustedStart = r.startIndex.advancedBy(offset)
                    let adjustedEnd = adjustedStart.advancedBy(replacementCount)
                    replacedRanges[i] = adjustedStart..<adjustedEnd
                }
            }
            let replacedRange = startIndex..<startIndex.advancedBy(replacementCount)
            replacedRanges.append(replacedRange)
            cumOffset = cumOffset + offset
        }

        return (mutatedSelf, replacedRanges)
    }
}

// (?:(?<!\\)#\{(\w+)\})
// The quick #{color} fox #{action} over #{subject}.
private let placeholderReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(\\w+)\\})"

extension String {
    public func replacing(placeholdersWithReplacements replacementsDict: [String : Any]) -> String {
        var ranges = [StringRange]()
        var replacements = [String]()

        let matches = placeholderReplacementRegex ~?? self
        for match in matches {
            let matchRange = range(fromNSRange: match.range)!
            let placeholderRange = range(fromNSRange: match.rangeAtIndex(1))!
            let replacementName = self[placeholderRange]
            if let replacement = replacementsDict[replacementName] {
                ranges.append(matchRange)
                replacements.append("\(replacement)")
            } else {
                logError("Replacement in \"\(self)\" not found for placeholder \"\(replacementName)\".")
            }
        }

        return replacing(ranges: ranges, withReplacements: replacements).string
    }
}

extension String {
    public func padded(toCount finalCount: Int, onRight: Bool = false, withCharacter character: Character = " ") -> String {
        let count = self.characters.count
        let padCount = finalCount - count
        guard padCount > 0 else { return self }
        let pad = String(count: padCount, repeatedValue: character)
        return onRight ? (self + pad) : (pad + self)
    }
}

extension String {
    public init(value: Double, precision: Int) {
        let f = NSNumberFormatter()
        f.numberStyle = .DecimalStyle
        f.usesGroupingSeparator = false
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = precision
        self.init(f.stringFromNumber(value)!)
    }

    public init(value: Float, precision: Int) {
        self.init(value: Double(value), precision: precision)
    }

    public init(value: CGFloat, precision: Int) {
        self.init(value: Double(value), precision: precision)
    }
}

infix operator %% { }

public func %% (left: Double, right: Int) -> String {
    return String(value: left, precision: right)
}

public func %% (left: Float, right: Int) -> String {
    return String(value: left, precision: right)
}

public func %% (left: CGFloat, right: Int) -> String {
    return String(value: left, precision: right)
}

#if os(iOS) || os(OSX) || os(tvOS)
public extension NSString {
    var cgFloatValue: CGFloat {
        get {
            return CGFloat(self.doubleValue)
        }
    }
}
#endif
