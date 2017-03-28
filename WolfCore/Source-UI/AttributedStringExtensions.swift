//
//  AttributedStringExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public typealias StringAttributes = [String : Any]
public let overrideTintColorTag = "overrideTintColor"

//
// Attributed String Conveniences
//

//
// *** Only one type of attributed string: AString.
//
// public typealias AString = NSMutableAttributedString
//
// The § postfix operator can be used to convert any Swift String, NSString, or NSAttributedString into an AString, so it can be manipulated further.
//
// Applying the § postfix operator to an existing AString makes a separate copy of it.
//
// This converts a straight Swift string to an AString
//
//    func example() -> AString {
//        let string = "The quick brown fox."
//        let attributedString = string§
//        return attributedString
//    }
//
// This retrieves the NSAttributedString from a UITextView and converts it to an AString
//
//    func example(textView: UITextView) -> AString {
//        let string = textView.attributedText  // This is an NSAttributedString
//        let attributedString = string§        // This is an AString (NSMutableAttributedString)
//        return attributedString
//    }
//
// This performs localization with placeholder replacement using the ¶ operator (see StringExtensions.swift), then uses the § operator to convert the result to an AString.
//
//    func example() -> AString {
//        let followersCount = 20
//        let template = "#{followersCount} followers." ¶ ["followersCount": followersCount]
//        return template§
//    }
//
//    func example() {
//        let s1 = "Hello."§ // Creates an AString
//        s1.foregroundColor = .red // s1 is now red
//
//        let s2 = s1 // Only copies the reference
//        s2.foregroundColor = .green // s1 and s2 are now green
//
//        let s3 = s1§ // This performs a true copy of s1
//
//        s3.foregroundColor = .blue // s1 and s2 are green, s3 is blue.
//    }
//

//
// *** Use Swift String range types with AttributedStrings, not NSRange.
//
// NSRange assumes underlying UTF-16 strings. NSRange instances with arbitrary `location` values may cut into characters that have more than one 16-bit word in their encoding. Swift has a better model for Strings which accounts for all underlying Unicode encodings and the fact that they may have variable-length characters ("extended grapheme clusters"). AString provides additional methods that take Swift String ranges, and which should be used instead of the existing methods that take NSRange instances.
//
// public typealias StringIndex = String.Index
// public typealias StringRange = Range<StringIndex>
//
// StringRange instances must be created in the context of the particular string to which they apply. Internally, a StringIndex carries a reference to the String from which it was created. Therefore, applying a StringIndex or StringRange created in the context of one string to another string without first converting it produces undefined results. Convenience methods are provided in StringExtensions.swift to convert StringIndex and StringRange instances between strings. Also, if you create a StringIndex or StringRange on a String and then mutate that string, the existing StringIndex or StringRange instances should be considered invalid for the mutated String.
//
//    func example() {
//        let string = "🐺❤️🇺🇸"
//        print("string has \(string.characters.count) extended grapheme clusters.")
//        print("As an NSString, string has \((string as NSString).length) UTF-16 words.")
//        let start = string.startIndex.advancedBy(1)
//        let end = start.advancedBy(2)
//        let range = start..<end
//        print(string.substringWithRange(range))
//    }
//
// Prints:
//
//    string has 3 extended grapheme clusters.
//    As an NSString, string has 8 UTF-16 words.
//    ❤️🇺🇸
//
// On the rare occasions you need to use literal integer offsets, you could just write:
// let range = string.range(start: 1, end: 3)
//
// ...or to create a range that covers the whole String:
// let range = string.range
//
// ...or to create a range that represents an insertion point:
// let index = string.index(start: 2)
//
//
// On the rare occasions you need to convert a Swift StringRange to an NSRange or vice-versa:
//
// let nsRange = string.nsRange(from: range)
//
// let range = string.range(from: nsRage)
//
//
// On the rare occasions you need to convert a Swift StringIndex to an NSRange.location:
//
// let location = string.location(fromIndex: stringIndex)
//
// let index = string.index(fromLocation: location)
//
//
// existing method: (DON'T USE)
//
// public func removeAttribute(name: String, range: NSRange)
//
//
// new method:
//
// public func remove(attributeNamed: String, fromRange: StringRange? = nil)
//
//
//    func example(s: AString) {
//        s.remove(attributeNamed: NSFontAttributeName) // removes attribute from entire string
//        let range = s.string.range(start: 0, end: 2)
//        s.remove(attributeNamed: NSFontAttributeName, fromRange: range) // removes attribute from just `range`.
//    }
//

//
// *** Attributes are added to AString instances by assignment.
//
// Common attributes such as font, foregroundColor, and paragraphStyle can be directly assigned as attributes.
//
//    func example() {
//        let attributedString = "The quick brown fox."§
//        attributedString.font = .boldSystemFont(ofSize: 18)
//        attributedString.foregroundColor = .red
//    }
//

//
// *** Attributes of substrings of AString instances are edited together.
//
//    func testString() {
//        let attributedString = "The quick brown fox."§
//        attributedString.font = .systemFont(ofSize: 18) // Applies to whole string
//        attributedString.foregroundColor = .gray
//
//        let range = attributedString.string.range(start: 10, end: 15) // "brown"
//        attributedString.edit(in: range) { substring in
//            substring.font = .boldSystemFont(ofSize: 18)
//            substring.foregroundColor = .red
//            // The word "brown" is now bold and red.
//        }
//
//        attributedString.printAttributes()
//    }
//
// Prints:
// Note: "NSFont" and "NSColor" are the attribute names, and correspond to NSFontAttributeName and NSForegroundColorAttributeName.
//
//    T NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    h NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    e NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//      NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    q NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    u NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    i NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    c NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    k NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//      NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    b NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
//    r NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
//    o NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
//    w NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
//    n NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
//      NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    f NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    o NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    x NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//    . NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
//

//
// *** User-defined attributes are added, accessed, and removed by subscripting. Remove an attribute by assigning nil.
//
//    func example() {
//        let attributedString = "The quick brown fox."§
//        let range = attributedString.string.range(start: 10, end: 15) // "brown"
//        let key = "myAttribute"
//
//        attributedString.edit(in: range) { substring in
//            // Assigns attribute to entire substring.
//            substring[key] = CGFloat(20.5)
//
//            // Retrieves value from first character of substring.
//            let value = substring[key] as! CGFloat
//            print(value) // prints "20.5"
//        }
//
//        attributedString.printAttributes()
//    }
//
// Prints:
//
//    20.5
//    T
//    h
//    e
//
//    q
//    u
//    i
//    c
//    k
//
//    b myAttribute:(0x00 25.5)
//    r myAttribute:(0x00 25.5)
//    o myAttribute:(0x00 25.5)
//    w myAttribute:(0x00 25.5)
//    n myAttribute:(0x00 25.5)
//
//    f
//    o
//    x
//    .
//

//
// *** "Tags" are user-defined attributes that always have type `Bool` and are always `true`.
//
//    func example() {
//        let attributedString = "The quick brown fox."§
//
//        let range1 = attributedString.string.range(start: 0, end: 3) // "The"
//        let key1 = "foo"
//        attributedString.edit(in: range1) { substring in
//            substring[key1] = CGFloat(25.5)
//        }
//
//        let range = attributedString.string.range(start: 10, end: 15) // "brown"
//        let key = "link"
//        attributedString.edit(in: range) { substring in
//            substring.addTag(key)
//        }
//
//        attributedString.printAttributes()
//    }
//
// Prints:
//
//    T foo:(0x00 25.5)
//    h foo:(0x00 25.5)
//    e foo:(0x00 25.5)
//
//    q
//    u
//    i
//    c
//    k
//
//    b link:(0x01 true)
//    r link:(0x01 true)
//    o link:(0x01 true)
//    w link:(0x01 true)
//    n link:(0x01 true)
//
//    f
//    o
//    x
//    .
//

//
// *** Tags and other attributes associated with those tags can be created from "template" strings.
//
// A template string example:
//
// The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}.
//
// Substrings of the form #{text|tag} can be created using a String convenience constructor:
//
//    func example() {
//        let string = String(text: "the lazy dog", tag: "subject")
//        print(string)
//    }
//
// Prints:
//
// #{the lazy dog|subject}
//
//
// Once a template String has been constructed, use String.attributedStringWithTags() to convert it to an AString:
//
//    func example() {
//        let template = "The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}."
//        let attributedString = template.attributedStringWithTags()
//        attributedString.printAttributes()
//    }
//
// Prints:
//
//    T
//    h
//    e
//
//    q
//    u
//    i
//    c
//    k
//
//    b color:(0x00 true)
//    r color:(0x00 true)
//    o color:(0x00 true)
//    w color:(0x00 true)
//    n color:(0x00 true)
//
//    f
//    o
//    x
//
//    j action:(0x00 true)
//    u action:(0x00 true)
//    m action:(0x00 true)
//    p action:(0x00 true)
//    s action:(0x00 true)
//
//    o
//    v
//    e
//    r
//
//    t subject:(0x00 true)
//    h subject:(0x00 true)
//    e subject:(0x00 true)
//      subject:(0x00 true)
//    l subject:(0x00 true)
//    a subject:(0x00 true)
//    z subject:(0x00 true)
//    y subject:(0x00 true)
//      subject:(0x00 true)
//    d subject:(0x00 true)
//    o subject:(0x00 true)
//    g subject:(0x00 true)
//    .
//
// Provide a closure to add additional attributes to each tag, or the string as a whole *before* each tag is added. The closure is called once with an empty string tag and a substring encompassing the entire string *before* it is called for each tag, allowing default attributes to be set that will be overridden by the tags.
//
//    func example() {
//        let template = "The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}."
//        let attrString = template.attributedStringWithTags() { (tag, substring) in
//            switch tag {
//            case "color":
//                substring.foregroundColor = .brown
//            case "action":
//                substring.foregroundColor = .red
//            case "subject":
//                substring.foregroundColor = .gray
//            default:
//                // The default clause is called *before* the tag-specific clauses.
//                substring.foregroundColor = .white
//                substring.font = .systemFont(ofSize: 12)
//                break
//            }
//        }
//        attrString.printAttributes()
//    }
//
// Prints:
//
//    T NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    h NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    e NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//      NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    q NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    u NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    i NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    c NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    k NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//      NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    b color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    r color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    o color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    w color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    n color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//      NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    f NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    o NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    x NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//      NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    j action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    u action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    m action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    p action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    s action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//      NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    o NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    v NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    e NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    r NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//      NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
//    t subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    h subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    e subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//      subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    l subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    a subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    z subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    y subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//      subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    d subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    o subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    g subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
//    . NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))

//    class MyTableViewCell: TableViewCell {
//        @IBOutlet weak var textView: TextView!
//
//        private let linkTag = "link"
//
//        override func awakeFromNib() {
//            super.awakeFromNib()
//
//            setupText()
//            setupTapActions()
//        }
//
//        private func setupText() {
//            let fontSize: CGFloat = 11
//            let link1Template = String(text: "http://google.com", tag: "link")
//            let link2Template = String(text: "http://bing.com", tag: "link")
//            let text = "To perform a search, visit \(link1Template) or \(link2Template)"
//            let attributedText = text.attributedStringWithTags() { (tag, substring) in
//                switch tag {
//                case self.linkTag:
//                    substring.font = .boldSystemFont(ofSize: fontSize)
//                    substring.foregroundColor = .blue
//                default:
//                    substring.font = .systemFont(ofSize: fontSize)
//                    substring.foregroundColor = .white
//                }
//            }
//            textView.attributedText = attributedText
//        }
//
//        private func setupTapActions() {
//            textView.setTapAction(forTag: linkTag) { [unowned self] urlText in
//                print("url tapped: \(urlText)")
//            }
//        }
//    }

// swiftlint:disable:next custom_rules
public typealias AString = NSMutableAttributedString

postfix operator §

public postfix func § (left: String) -> AString {
    return AString(string: left)
}

public postfix func § (left: AString) -> AString {
    return left.mutableCopy() as! AString
}

public postfix func § (left: String?) -> AString? {
    guard let left = left else { return nil }
    return AString(string: left)
}

public postfix func § (left: AString?) -> AString? {
    guard let left = left else { return nil }
    return left.mutableCopy() as? AString
}

// swiftlint:disable:next custom_rules
public postfix func § (left: NSAttributedString) -> AString {
    return left.mutableCopy() as! AString
}
// swiftlint:disable:next custom_rules
public postfix func § (left: NSAttributedString?) -> AString? {
    guard let left = left else { return nil }
    return left.mutableCopy() as? AString
}

// swiftlint:disable:next custom_rules
public func += (left: AString, right: NSAttributedString) {
    left.append(right)
}


extension AString {
    public var count: Int {
        return string.characters.count
    }

    public func attributedSubstring(from range: Range<String.Index>) -> AString {
        return attributedSubstring(from: string.nsRange(from: range)!)§
    }

    public func attributes(at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> StringAttributes {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
        let attrs = attributes(at: location, longestEffectiveRange: nil, in: nsRangeLimit)
        return attrs
    }

    public func attributesWithLongestEffectiveRange(at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> (attributes: StringAttributes, longestEffectiveRange: Range<String.Index>) {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
        var nsRange = NSRange()
        let attrs = attributes(at: location, longestEffectiveRange: &nsRange, in: nsRangeLimit)
        let range = string.stringRange(from: nsRange)!
        return (attrs, range)
    }

    public func attribute(_ name: String, at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> Any? {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
        let attr = attribute(name, at: location, longestEffectiveRange: nil, in: nsRangeLimit)
        return attr
    }

    public func attributeWithLongestEffectiveRange(_ name: String, at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> (attribute: Any?, longestEffectiveRange: Range<String.Index>) {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
        var nsRange = NSRange()
        let attr = attribute(name, at: location, longestEffectiveRange: &nsRange, in: nsRangeLimit)
        let range = string.stringRange(from: nsRange)!
        return (attr, range)
    }

    // swiftlint:disable:next custom_rules
    public func enumerateAttributes(in enumerationRange: Range<String.Index>? = nil, options opts: NSAttributedString.EnumerationOptions = [], using block: (StringAttributes, Range<String.Index>, ASubstring) -> Bool) {
        let nsRange = string.nsRange(from: enumerationRange) ?? string.nsRange
        enumerateAttributes(in: nsRange, options: opts) { (attrs, nsRange, stop) in
            let range = self.string.stringRange(from: nsRange)!
            stop[0] = ObjCBool(block(attrs, range, self.substring(in: range)))
        }
    }

    // swiftlint:disable:next custom_rules
    public func enumerateAttribute(_ name: String, in enumerationRange: Range<String.Index>? = nil, options opts: NSAttributedString.EnumerationOptions = [], using block: (Any?, Range<String.Index>, ASubstring) -> Bool) {
        let nsEnumerationRange = string.nsRange(from: enumerationRange) ?? string.nsRange
        enumerateAttribute(name, in: nsEnumerationRange, options: opts) { (value, nsRange, stop) in
            let range = self.string.stringRange(from: nsRange)!
            stop[0] = ObjCBool(block(value, range, self.substring(in: range)))
        }
    }

    public func replaceCharacters(in range: Range<String.Index>, with str: String) {
        let nsRange = string.nsRange(from: range)!
        replaceCharacters(in: nsRange, with: str)
    }

    public func setAttributes(_ attrs: StringAttributes?, range: Range<String.Index>? = nil) {
        let nsRange = string.nsRange(from: range) ?? string.nsRange
        setAttributes(attrs, range: nsRange)
    }

    public func addAttribute(_ name: String, value: Any, range: Range<String.Index>? = nil) {
        let nsRange = string.nsRange(from: range) ?? string.nsRange
        addAttribute(name, value: value, range: nsRange)
    }

    public func addAttributes(_ attrs: StringAttributes, range: Range<String.Index>? = nil) {
        let nsRange = string.nsRange(from: range) ?? string.nsRange
        addAttributes(attrs, range: nsRange)
    }

    public func removeAttribute(_ name: String, range: Range<String.Index>? = nil) {
        let nsRange = string.nsRange(from: range) ?? string.nsRange
        removeAttribute(name, range: nsRange)
    }

    public func replaceCharacters(in range: Range<String.Index>, with attrString: AString) {
        let nsRange = string.nsRange(from: range)!
        replaceCharacters(in: nsRange, with: attrString)
    }

    public func insert(_ attrString: AString, at index: String.Index) {
        let location = string.location(fromIndex: index)
        insert(attrString, at: location)
    }

    public func deleteCharacters(in range: Range<String.Index>) {
        let nsRange = string.nsRange(from: range)!
        deleteCharacters(in: nsRange)
    }
}

extension AString {
    public func substring(in range: Range<String.Index>? = nil) -> ASubstring {
        return ASubstring(string: self, range: range)
    }

    public func substring(from index: String.Index) -> ASubstring {
        return ASubstring(string: self, fromIndex: index)
    }

    public func substrings(withTag tag: String) -> [ASubstring] {
        var result = [ASubstring]()

        var index = string.startIndex
        while index < string.endIndex {
            let (attrs, longestEffectiveRange) = attributesWithLongestEffectiveRange(at: index)
            if attrs[tag] as? Bool == true {
                let substring = ASubstring(string: self, range: longestEffectiveRange)
                result.append(substring)
                index = longestEffectiveRange.upperBound
            }
            index = string.index(index, offsetBy: 1)
        }

        return result
    }
}

extension AString {
    public var font: OSFont {
        get { return substring().font }
        set { substring().font = newValue }
    }

    public var foregroundColor: OSColor {
        get { return substring().foregroundColor }
        set { substring().foregroundColor = newValue }
    }

    public var paragraphStyle: NSMutableParagraphStyle {
        get { return substring().paragraphStyle }
        set { substring().paragraphStyle = newValue }
    }

    public var textAlignment: NSTextAlignment {
        get { return substring().textAlignment }
        set { substring().textAlignment = newValue }
    }

    public var tag: String {
        get { return substring().tag }
        set { substring().tag = newValue }
    }

    public subscript(attribute: String) -> Any? {
        get { return substring()[attribute] }
        set { substring()[attribute] = newValue! }
    }

    public func getString(forTag tag: String, atIndex index: String.Index) -> String? {
        return substring(from: index).getString(forTag: tag)
    }

    public func has(tag: String, atIndex index: String.Index) -> Bool {
        return substring(from: index).hasTag(tag)
    }

    public func edit(f: (ASubstring) -> Void) {
        beginEditing()
        f(substring())
        endEditing()
    }

    public func edit(in range: Range<String.Index>, f: (ASubstring) -> Void) {
        beginEditing()
        f(substring(in: range))
        endEditing()
    }
}

extension AString {
    public func printAttributes() {
        let aliaser = ObjectAliaser()
        var strIndex = string.startIndex
        for char in string.characters {
            let joiner = Joiner()
            joiner.append(char)
            let attrs: StringAttributes = attributes(at: strIndex)
            for(name, value) in attrs {
                let v = value as AnyObject
                joiner.append("\(name):\(aliaser.name(forObject: v))")
            }
            print(joiner)
            strIndex = string.index(strIndex, offsetBy: 1)
        }
    }
}

public class ASubstring {
    public let attrString: AString
    public let strRange: Range<String.Index>
    public let nsRange: NSRange

    public init(string attrString: AString, range strRange: Range<String.Index>? = nil) {
        self.attrString = attrString
        self.strRange = strRange ?? attrString.string.stringRange
        self.nsRange = attrString.string.nsRange(from: self.strRange)!
    }

    public convenience init(string attrString: AString, fromIndex index: String.Index) {
        self.init(string: attrString, range: index..<attrString.string.endIndex)
    }

    public convenience init(string attrString: AString) {
        self.init(string: attrString, range: attrString.string.startIndex..<attrString.string.endIndex)
    }

    public var count: Int {
        return attrString.string.distance(from: strRange.lowerBound, to: strRange.upperBound)
    }

    public var attributedSubstring: AString {
        return attrString.attributedSubstring(from: strRange)
    }

    public func attributes(in rangeLimit: Range<String.Index>? = nil) -> StringAttributes {
        return attrString.attributes(at: strRange.lowerBound, in: rangeLimit)
    }

    public func attributesWithLongestEffectiveRange(in rangeLimit: Range<String.Index>? = nil) -> (attributes: StringAttributes, longestEffectiveRange: Range<String.Index>) {
        return attrString.attributesWithLongestEffectiveRange(at: strRange.lowerBound, in: rangeLimit)
    }

    public func attribute(_ name: String, in rangeLimit: Range<String.Index>? = nil) -> Any? {
        return attrString.attribute(name, at: strRange.lowerBound, in: rangeLimit)
    }

    public func attributeWithLongestEffectiveRange(_ name: String, in rangeLimit: Range<String.Index>? = nil) -> (attribute: Any?, longestEffectiveRange: Range<String.Index>) {
        return attrString.attributeWithLongestEffectiveRange(name, at: strRange.lowerBound, in: rangeLimit)
    }

    // swiftlint:disable:next custom_rules
    public func enumerateAttributes(options opts: NSAttributedString.EnumerationOptions = [], using block: (StringAttributes, Range<String.Index>, ASubstring) -> Bool) {
        attrString.enumerateAttributes(in: strRange, options: opts, using: block)
    }

    // swiftlint:disable:next custom_rules
    public func enumerateAttribute(_ name: String, options opts: NSAttributedString.EnumerationOptions = [], using block: (Any?, Range<String.Index>, ASubstring) -> Bool) {
        attrString.enumerateAttribute(name, in: strRange, options: opts, using: block)
    }

    public func setAttributes(_ attrs: StringAttributes?) {
        attrString.setAttributes(attrs, range: strRange)
    }

    public func addAttribute(_ name: String, value: Any) {
        attrString.addAttribute(name, value: value, range: strRange)
    }

    public func addAttributes(_ attrs: StringAttributes) {
        attrString.addAttributes(attrs, range: strRange)
    }

    public func removeAttribute(_ name: String) {
        attrString.removeAttribute(name, range: strRange)
    }
}

extension ASubstring : CustomStringConvertible {
    public var description: String {
        let s = attrString.string.substring(with: strRange)
        return "(ASubstring attrString:\(s), strRange:\(strRange))"
    }
}

extension ASubstring {
    public func addTag(_ tag: String) {
        self[tag] = true
    }

    public func getRange(forTag tag: String) -> Range<String.Index>? {
        let (value, longestEffectiveRange) = attributeWithLongestEffectiveRange(tag)
        if value is Bool {
            return longestEffectiveRange
        } else {
            return nil
        }
    }

    public func getString(forTag tag: String) -> String? {
        if let range = getRange(forTag: tag) {
            return attrString.string[range]
        } else {
            return nil
        }
    }

    public func hasTag(_ tag: String) -> Bool {
        return getRange(forTag: tag) != nil
    }

    public subscript(name: String) -> Any? {
        get {
            return attribute(name)
        }
        set {
            if let newValue = newValue {
                addAttribute(name, value: newValue)
            } else {
                removeAttribute(name)
            }
        }
    }

    public var font: OSFont {
        get {
            return attribute(NSFontAttributeName) as? OSFont ?? OSFont.systemFont(ofSize: 12)
        }
        set { addAttribute(NSFontAttributeName, value: newValue) }
    }

    public var foregroundColor: OSColor {
        get { return attribute(NSForegroundColorAttributeName) as? OSColor ?? .black }
        set { addAttribute(NSForegroundColorAttributeName, value: newValue) }
    }

    public var paragraphStyle: NSMutableParagraphStyle {
        get {
            if let value = attribute(NSParagraphStyleAttributeName) as? NSParagraphStyle {
                return value.mutableCopy() as! NSMutableParagraphStyle
            } else {
                return NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            }
        }
        set { addAttribute(NSParagraphStyleAttributeName, value: newValue) }
    }

    public var textAlignment: NSTextAlignment {
        get {
            return self.paragraphStyle.alignment
        }
        set {
            let paragraphStyle = self.paragraphStyle
            paragraphStyle.alignment = newValue
            self.paragraphStyle = paragraphStyle
        }
    }

    public var tag: String {
        get { fatalError("Unimplemented.") }
        set { addTag(newValue) }
    }

    public var overrideTintColor: Bool {
        get { return hasTag(overrideTintColorTag) }
        set {
            if newValue {
                addTag(overrideTintColorTag)
            } else {
                removeAttribute(overrideTintColorTag)
            }
        }
    }
}

// swiftlint:disable:next custom_rules
extension NSAttributedString {
    public func height(forWidth width: CGFloat, context: NSStringDrawingContext? = nil) -> CGFloat {
        let maxBounds = CGSize(width: width, height: .greatestFiniteMagnitude)
        let bounds = boundingRect(with: maxBounds, options: [.usesLineFragmentOrigin], context: context)
        return ceil(bounds.height)
    }

    public func width(forHeight height: CGFloat, context: NSStringDrawingContext? = nil) -> CGFloat {
        let maxBounds = CGSize(width: .greatestFiniteMagnitude, height: height)
        let bounds = boundingRect(with: maxBounds, options: [.usesLineFragmentOrigin], context: context)
        return ceil(bounds.width)
    }
}

// swiftlint:enable ns_attributed_string

// (?:(?<!\\)#\{(.*?)\|(\w+)\})
// The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}.
private let tagsReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(.*?)\\|(\\w+)\\})"

extension String {
    public init(text: String, tag: String) {
        self.init("#{\(text)|\(tag)}")!
    }

    public func attributedStringWithTags(tagEditBlock: ((_ tag: String, _ substring: ASubstring) -> Void)? = nil) -> AString {
        var tags = [String]()

        let matches = tagsReplacementRegex ~?? self
        let replacements = matches.map { match -> (Range<String.Index>, String) in
            let matchRange = stringRange(from: match.range)!

            let textRange = stringRange(from: match.rangeAt(1))!
            let tagRange = stringRange(from: match.rangeAt(2))!

            let text = self.substring(with: textRange)
            let tag = self.substring(with: tagRange)

            tags.append(tag)
            return (matchRange, text)
        }

        let (string, replacedRanges) = replacing(replacements: replacements)
        let attributedString = string§

        tagEditBlock?("", attributedString.substring())

        for (index, tag) in tags.enumerated() {
            let replacedRange = replacedRanges[index]
            attributedString.edit(in: replacedRange) { substring in
                substring.addTag(tag)
                tagEditBlock?(tag, substring)
            }
        }

        return attributedString
    }
}
