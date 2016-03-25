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
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public func localized(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
#endif

extension String {
    public func paddedToCount(finalCount: Int, onRight: Bool = false, withCharacter character: Character = " ") -> String {
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
