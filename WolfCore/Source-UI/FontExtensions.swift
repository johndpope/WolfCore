//
//  FontExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/9/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSFont = UIFont
    public typealias OSFontDescriptor = UIFontDescriptor
#elseif os(macOS)
    import Cocoa
    public typealias OSFont = NSFont
    public typealias OSFontDescriptor = NSFontDescriptor
#endif

#if os(iOS) || os(tvOS)
    extension UIFont {
        public var isBold: Bool {
            return fontDescriptor.symbolicTraits.contains(.traitBold)
        }

        public var isItalic: Bool {
            return fontDescriptor.symbolicTraits.contains(.traitItalic)
        }
    }
#elseif os(macOS)
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
            return UIFont(descriptor: fontDescriptor.withSymbolicTraits([])!, size: 0)
        }

        public var boldVariant: UIFont {
            return UIFont(descriptor: fontDescriptor.withSymbolicTraits([.traitBold])!, size: 0)
        }

        public var italicVariant: UIFont {
            return UIFont(descriptor: fontDescriptor.withSymbolicTraits([.traitItalic])!, size: 0)
        }
    }
#elseif os(macOS)
    extension NSFont {
        public var plainVariant: NSFont {
            return NSFont(descriptor: fontDescriptor.withSymbolicTraits(0), size: 0)!
        }

        public var boldVariant: NSFont {
            return NSFont(descriptor: fontDescriptor.withSymbolicTraits(NSFontSymbolicTraits(NSFontBoldTrait)), size: 0)!
        }

        public var italicVariant: NSFont {
            return NSFont(descriptor: fontDescriptor.withSymbolicTraits(NSFontSymbolicTraits(NSFontItalicTrait)), size: 0)!
        }
    }
#endif
