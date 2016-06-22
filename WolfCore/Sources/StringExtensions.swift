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
public typealias Replacements = [String: String]
public typealias RangeReplacement = (StringRange, String)

extension Log.GroupName {
    public static let localization = Log.GroupName("localization")
}

// Provide concise versions of NSLocalizedString.

#if os(iOS) || os(OSX) || os(tvOS)
    postfix operator ¶ { }

    public postfix func ¶ (left: String) -> String {
        return left.localized()
    }

    infix operator ¶ { associativity left precedence 95 }

    public func ¶ (left: String, right: Replacements) -> String {
        return left.localized(replacingPlaceholdersWithReplacements: right)
    }

    public func ¶ (left: String, right: AnyClass) -> String {
        return left.localized(inBundleForClass: right)
    }

    public func ¶ (left: String, right: (aClass: AnyClass, replacements: Replacements)) -> String {
        return left.localized(inBundleForClass: right.aClass, replacingPlaceholdersWithReplacements: right.replacements)
    }
#endif

#if os(iOS) || os(OSX) || os(tvOS)
    extension String {
        public func localized(onlyIfTagged mustHaveTag: Bool = false, inBundleForClass aClass: AnyClass? = nil, inLanguage language: String? = nil, replacingPlaceholdersWithReplacements replacements: Replacements? = nil) -> String {

            let untaggedKey: String
            let taggedKey: String
            let hasTag: Bool
            if self.hasSuffix("¶") {
                untaggedKey = substring(to: self.index(self.endIndex, offsetBy: -1))
                taggedKey = self
                hasTag = true
            } else {
                untaggedKey = self
                taggedKey = self + "¶"
                hasTag = false
            }

            guard !mustHaveTag || hasTag else { return self }

            var bundle = Bundle.findBundle(forClass: aClass)
            if let language = language {
                if let path = bundle.pathForResource(language, ofType: "lproj") {
                    if let langBundle = Bundle(path: path) {
                        bundle = langBundle
                    }
                }
            }
            var localized = bundle.localizedString(forKey: taggedKey, value: nil, table: nil)
            if localized == taggedKey {
                localized = Bundle.findBundle(forClass: BundleClass.self).localizedString(forKey: taggedKey, value: nil, table: nil)
            }
            if localized == taggedKey {
                logWarning("No localization found for: \"\(taggedKey)\".", group: .localization)
                localized = untaggedKey
            }
            if let replacements = replacements {
                localized = localized.replacingPlaceholders(withReplacements: replacements)
            }
            return localized
        }
    }
#endif

extension String {
    public func range(from nsRange: NSRange?) -> StringRange? {
        guard let nsRange = nsRange else { return nil }
        let utf16view = utf16
        let from16 = utf16view.index(utf16view.startIndex, offsetBy: nsRange.location, limitedBy: utf16view.endIndex)!
        let to16 = utf16view.index(from16, offsetBy: nsRange.length, limitedBy: utf16view.endIndex)!
        if let from = StringIndex(from16, within: self),
            let to = StringIndex(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    public func nsRange(from range: StringRange?) -> NSRange? {
        guard let range = range else { return nil }
        let utf16view = utf16
        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)
        let to = String.UTF16View.Index(range.upperBound, within: utf16view)
        let location = utf16view.distance(from: utf16view.startIndex, to: from)
        let length = utf16view.distance(from: from, to: to)
        return NSRange(location: location, length: length)
    }

    public func location(fromIndex index: StringIndex) -> Int {
        return nsRange(from: index..<index)!.location
    }

    public func index(fromLocation location: Int) -> StringIndex {
        return range(from: NSRange(location: location, length: 0))!.lowerBound
    }

    public var nsRange: NSRange {
        return nsRange(from: range)!
    }

    public var range: StringRange {
        return startIndex..<endIndex
    }

    public func range(start: Int, end: Int? = nil) -> StringRange {
        let s = self.index(self.startIndex, offsetBy: start)
        let e = self.index(self.startIndex, offsetBy: (end ?? start))
        return s..<e
    }
}

extension String {
    public func convert(index: StringIndex, fromString string: String, offset: Int = 0) -> StringIndex {
        let distance = string.distance(from: string.startIndex, to: index) + offset
        return self.index(self.startIndex, offsetBy: distance)
    }

    public func convert(index: StringIndex, toString string: String, offset: Int = 0) -> StringIndex {
        let distance = self.distance(from: self.startIndex, to: index) + offset
        return string.index(string.startIndex, offsetBy: distance)
    }

    public func convert(range: StringRange, fromString string: String, offset: Int = 0) -> StringRange {
        let s = convert(index: range.lowerBound, fromString: string, offset: offset)
        let e = convert(index: range.upperBound, fromString: string, offset: offset)
        return s..<e
    }

    public func convert(range: StringRange, toString string: String, offset: Int = 0) -> StringRange {
        let s = convert(index: range.lowerBound, toString: string, offset: offset)
        let e = convert(index: range.upperBound, toString: string, offset: offset)
        return s..<e
    }
}

extension String {
    public func replacing(replacements: [RangeReplacement]) -> (string: String, ranges: [StringRange]) {
        let source = self
        var target = self
        var targetReplacedRanges = [StringRange]()

        var cumOffset = 0
        for (sourceRange, replacement) in replacements {
            let replacementCount = replacement.characters.count
            let rangeCount = source.distance(from: sourceRange.lowerBound, to: sourceRange.upperBound)
            let offset = replacementCount - rangeCount

            let newTargetStartIndex: StringIndex
            let originalTarget = target
            do {
                let targetStartIndex = target.convert(index: sourceRange.lowerBound, fromString: source, offset: cumOffset)
                let targetEndIndex = target.index(targetStartIndex, offsetBy: rangeCount)
                let targetReplacementRange = targetStartIndex..<targetEndIndex
                target.replaceSubrange(targetReplacementRange, with: replacement)
                newTargetStartIndex = target.convert(index: targetStartIndex, fromString: originalTarget)
            }

            targetReplacedRanges = targetReplacedRanges.map { originalTargetReplacedRange in
                let targetReplacedRange = target.convert(range: originalTargetReplacedRange, fromString: originalTarget)
                guard targetReplacedRange.lowerBound >= newTargetStartIndex else {
                    return targetReplacedRange
                }
                let adjustedStart = target.index(targetReplacedRange.lowerBound, offsetBy: offset)
                let adjustedEnd = target.index(adjustedStart, offsetBy: replacementCount)
                return adjustedStart..<adjustedEnd
            }
            let targetEndIndex = target.index(newTargetStartIndex, offsetBy: replacementCount)
            let targetReplacedRange = newTargetStartIndex..<targetEndIndex
            targetReplacedRanges.append(targetReplacedRange)
            cumOffset = cumOffset + offset
        }

        return (target, targetReplacedRanges)
    }
}

extension String {
    public func replacing(matchesTo regex: RegularExpression, usingBlock block: (RangeReplacement) -> String) -> (string: String, ranges: [StringRange]) {
        let results = (regex ~?? self).map { match -> RangeReplacement in
            let matchRange = match.range(atIndex: 0, inString: self)
            let substring = self.substring(with: matchRange)
            let replacement = block(matchRange, substring)
            return (matchRange, replacement)
        }
        return replacing(replacements: results)
    }
}

private let newlinesRegex = try! ~/"\n"

extension String {
    public func escapingNewlines() -> String {
        return replacing(matchesTo: newlinesRegex) { (string, range) -> String in
            return "\\n"
        }.string
    }

    public func truncate(afterCount count: Int, addingSignifier signifier: String = "…") -> String {
        guard characters.count > count else { return self }
        let s = substring(with: startIndex..<index(startIndex, offsetBy: count))
        return "\(s)\(signifier)"
    }

    public var debugSummary: String {
        return escapingNewlines().truncate(afterCount: 20)
    }
}

// (?:(?<!\\)#\{(\w+)\})
// The quick #{color} fox #{action} over #{subject}.
private let placeholderReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(\\w+)\\})"

extension String {
    public func replacingPlaceholders(withReplacements replacementsDict: Replacements) -> String {
        var replacements = [RangeReplacement]()
        let matches = placeholderReplacementRegex ~?? self
        for match in matches {
            let matchRange = range(from: match.range)!
            let placeholderRange = range(from: match.range(at: 1))!
            let replacementName = self[placeholderRange]
            if let replacement = replacementsDict[replacementName] {
                replacements.append((matchRange, replacement))
            } else {
                logError("Replacement in \"\(self)\" not found for placeholder \"\(replacementName)\".")
            }
        }

        return replacing(replacements: replacements).string
    }
}

extension String {
    public func padded(toCount finalCount: Int, onRight: Bool = false, withCharacter character: Character = " ") -> String {
        let count = self.characters.count
        let padCount = finalCount - count
        guard padCount > 0 else { return self }
        let pad = String(repeating: character, count: padCount)
        return onRight ? (self + pad) : (pad + self)
    }

    public static func padded(toCount finalCount: Int, onRight: Bool = false, withCharacter character: Character = " ") -> (String) -> String {
        return { $0.padded(toCount: finalCount, onRight: onRight, withCharacter: character) }
    }
}

extension String {
    public init(value: Double, precision: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        self.init(formatter.string(from: value)!)
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
