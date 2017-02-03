//
//  StringExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/13/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public typealias StringIndex = String.Index
public typealias StringRange = Range<StringIndex>
public typealias Replacements = [String: String]
public typealias RangeReplacement = (StringRange, String)

extension Log.GroupName {
    public static let localization = Log.GroupName("localization")
}

// Provide concise versions of NSLocalizedString.

postfix operator ¶

public postfix func ¶ (left: String) -> String {
    return left.localized()
}

infix operator ¶ : AttributeAssignmentPrecedence

public func ¶ (left: String, right: Replacements) -> String {
    return left.localized(replacingPlaceholdersWithReplacements: right)
}

private var _localizationTableNames = [String?]()
public var localizationTableNames = [String]() {
    didSet {
        _localizationTableNames = []
        localizationTableNames.forEach { _localizationTableNames.append($0) }
        _localizationTableNames.append(nil)
    }
}

public var localizationBundles = [Bundle.main]

extension String {
    public func localized(onlyIfTagged mustHaveTag: Bool = false, inLanguage language: String? = nil, replacingPlaceholdersWithReplacements replacements: Replacements? = nil) -> String {
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

        var s: String?
        for bundle in localizationBundles {
            s = localized(key: taggedKey, in: bundle, inLanguage: language)
            if s != nil { break }
        }

        if s == nil {
            logWarning("No localization found for: \"\(taggedKey)\".", group: .localization)
            s = untaggedKey
        }

        if let replacements = replacements {
            s = s!.replacingPlaceholders(withReplacements: replacements)
        }

        return s!
    }

    private func localized(key: String, in bundle: Bundle, inLanguage language: String?) -> String? {
        var bundle = bundle

        if let language = language {
            if let path = bundle.path(forResource: language, ofType: "lproj") {
                if let langBundle = Bundle(path: path) {
                    bundle = langBundle
                }
            }
        }

        var localized: String?
        let notFoundValue = "⁉️"
        for tableName in _localizationTableNames {
            let s = bundle.localizedString(forKey: key, value: notFoundValue, table: tableName)
            if s != notFoundValue {
                localized = s
                break
            }
        }

        return localized
    }
}

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

    public func range(r: Range<Int>) -> StringRange {
        return range(start: r.lowerBound, end: r.upperBound)
    }

    public func substring(start: Int, end: Int? = nil) -> String {
        return substring(with: range(start: start, end: end))
    }

    public func substring(r: Range<Int>) -> String {
        return substring(start: r.lowerBound, end: r.upperBound)
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
        let sortedReplacements = replacements.sorted { $0.0.lowerBound < $1.0.lowerBound }

        var totalOffset = 0
        for (sourceRange, replacement) in sortedReplacements {
            let replacementCount = replacement.characters.count
            let rangeCount = source.distance(from: sourceRange.lowerBound, to: sourceRange.upperBound)
            let offset = replacementCount - rangeCount

            let newTargetStartIndex: StringIndex
            let originalTarget = target
            do {
                let targetStartIndex = target.convert(index: sourceRange.lowerBound, fromString: source, offset: totalOffset)
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
            totalOffset = totalOffset + offset
        }

        return (target, targetReplacedRanges)
    }
}

extension String {
    public func replacing(matchesTo regex: NSRegularExpression, usingBlock block: (RangeReplacement) -> String) -> (string: String, ranges: [StringRange]) {
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
            let placeholderRange = range(from: match.rangeAt(1))!
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

// Support the Serializable protocol used for caching

extension String: Serializable {
    public typealias ValueType = String

    public func serialize() -> Data {
        return self |> UTF8.init |> Data.init
    }

    public static func deserialize(from data: Data) throws -> String {
        return try data |> UTF8.init |> String.init
    }
}

extension String {
    public func padded(to count: Int, onRight: Bool = false, with character: Character = " ") -> String {
        let startCount = self.characters.count
        let padCount = count - startCount
        guard padCount > 0 else { return self }
        let pad = String(repeating: String(character), count: padCount)
        return onRight ? (self + pad) : (pad + self)
    }

    public static func padded(to count: Int, onRight: Bool = false, with character: Character = " ") -> (String) -> String {
        return { $0.padded(to: count, onRight: onRight, with: character) }
    }

    public func paddedWithZeros(to count: Int) -> String {
        return padded(to: count, onRight: false, with: "0")
    }

    public static func paddedWithZeros(to count: Int) -> (String) -> String {
        return { $0.paddedWithZeros(to: count) }
    }
}

extension String {
    public func split(by size: Int) -> [String] {
        var parts = [String]()
        var start = startIndex
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            parts.append(substring(with: start ..< end))
            start = end
        }
        return parts
    }
}

#if !os(Linux)

extension String {
    public func height(forWidth width: CGFloat, font: OSFont, context: NSStringDrawingContext? = nil) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: context)

        return boundingBox.height
    }

    public func width(forHeight height: CGFloat, font: OSFont, context: NSStringDrawingContext? = nil) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: context)

        return boundingBox.width
    }
}

#endif

extension String {
    public init(value: Double, precision: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        self.init(formatter.string(from: NSNumber(value: value))!)!
    }

    public init(value: Float, precision: Int) {
        self.init(value: Double(value), precision: precision)
    }

    public init(value: CGFloat, precision: Int) {
        self.init(value: Double(value), precision: precision)
    }
}

infix operator %%

public func %% (left: Double, right: Int) -> String {
    return String(value: left, precision: right)
}

public func %% (left: Float, right: Int) -> String {
    return String(value: left, precision: right)
}

public func %% (left: CGFloat, right: Int) -> String {
    return String(value: left, precision: right)
}

#if !os(Linux)
public extension NSString {
    var cgFloatValue: CGFloat {
        get {
            return CGFloat(self.doubleValue)
        }
    }
}
#endif

public struct StringName: ExtensibleEnumeratedName, Reference {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }

    // Reference
    public var referent: String {
        return name¶
    }
}

public postfix func ® (lhs: StringName) -> String {
    return lhs.referent
}

public func tabs(_ count: Int) -> String {
    return String(repeating: "\t", count: count)
}
