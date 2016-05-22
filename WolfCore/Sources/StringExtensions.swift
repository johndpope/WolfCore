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
extension String {
    public func localized(inBundleForClass aClass: AnyClass? = nil, replacingPlaceholdersWithReplacements replacements: [String : Any]? = nil) -> String {
        let bundle = NSBundle.findBundle(forClass: aClass)
        var s = bundle.localizedStringForKey(self, value: nil, table: nil)
        if s == self {
            s = NSBundle.findBundle(forClass: BundleClass.self).localizedStringForKey(self, value: nil, table: nil)
        }
        if let replacements = replacements {
            s = s.replacing(placeholdersWithReplacements: replacements)
        }
        return s
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
