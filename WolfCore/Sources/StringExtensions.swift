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
    public func range(fromNSRange range: NSRange) -> Range<String.Index> {
        let s = self.startIndex.advancedBy(range.location)
        let e = self.startIndex.advancedBy(range.location + range.length)
        return s..<e
    }

    public var nsRange: NSRange {
        return NSRange(location: 0, length: (self as NSString).length)
    }
}

private let _placeholderReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(\\w+)\\})"

extension String {
    public func replacing(placeholdersWithReplacements replacements: [String : Any]) -> String {
        var mutatedSelf = self
        // (?:(?<!\\)#{(\w+)})
        let matches = _placeholderReplacementRegex.matchesInString(self, options: [], range: nsRange) as Array<NSTextCheckingResult>
        for match in matches.reverse() {
            let matchRange = range(fromNSRange: match.range)
            let placeholderRange = range(fromNSRange: match.rangeAtIndex(1))
            let replacementName = mutatedSelf[placeholderRange]
            if let replacement = replacements[replacementName] {
                mutatedSelf.replaceRange(matchRange, with: "\(replacement)")
            } else {
                logError("Replacement in \"\(self)\" not found for placeholder \"\(replacementName)\".")
            }
        }
        return mutatedSelf
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

#if os(iOS) || os(OSX) || os(tvOS)
public extension NSString {
    var cgFloatValue: CGFloat {
        get {
            return CGFloat(self.doubleValue)
        }
    }
}
#endif
