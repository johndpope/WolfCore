//
//  FontExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 6/9/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSFont = UIFont
    public typealias OSFontDescriptor = UIFontDescriptor
#elseif os(OSX)
    import Cocoa
    public typealias OSFont = NSFont
    public typealias OSFontDescriptor = NSFontDescriptor
#endif

#if os(iOS) || os(tvOS)
    extension UIFont {
        public var isBold: Bool {
            return fontDescriptor().symbolicTraits.contains(.TraitBold)
        }

        public var isItalic: Bool {
            return fontDescriptor().symbolicTraits.contains(.TraitItalic)
        }
    }
#elseif os(OSX)
    extension NSFont {
        public var isBold: Bool {
            return (fontDescriptor.symbolicTraits | NSFontSymbolicTraits(NSFontBoldTrait)) != 0
        }

        public var isItalic: Bool {
            return (fontDescriptor.symbolicTraits | NSFontSymbolicTraits(NSFontItalicTrait)) != 0
        }
    }
#endif

#if os(iOS) || os(tvOS)
    extension UIFont {
        public var plainVariant: UIFont {
            return UIFont(descriptor: fontDescriptor().fontDescriptorWithSymbolicTraits([]), size: 0)
        }

        public var boldVariant: UIFont {
            return UIFont(descriptor: fontDescriptor().fontDescriptorWithSymbolicTraits([.TraitBold]), size: 0)
        }

        public var italicVariant: UIFont {
            return UIFont(descriptor: fontDescriptor().fontDescriptorWithSymbolicTraits([.TraitItalic]), size: 0)
        }
    }
#elseif os(OSX)
    extension NSFont {
        public var plainVariant: NSFont {
            return NSFont(descriptor: fontDescriptor.fontDescriptorWithSymbolicTraits(0), size: 0)!
        }

        public var boldVariant: NSFont {
            return NSFont(descriptor: fontDescriptor.fontDescriptorWithSymbolicTraits(NSFontSymbolicTraits(NSFontBoldTrait)), size: 0)!
        }

        public var italicVariant: NSFont {
            return NSFont(descriptor: fontDescriptor.fontDescriptorWithSymbolicTraits(NSFontSymbolicTraits(NSFontItalicTrait)), size: 0)!
        }
    }
#endif
