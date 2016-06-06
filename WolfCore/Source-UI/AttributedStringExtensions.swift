//
//  AttributedStringExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 5/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public typealias StringAttributes = [String : AnyObject]
public let overrideTintColorTag = "overrideTintColor"

//
// Attributed String Conveniences
//

//
// *** Only one type of attributed string: AttributedString.
//
// public typealias AttributedString = NSMutableAttributedString
//
// The § postfix operator can be used to convert any Swift String, NSString, or NSAttributedString into an AttributedString, so it can be manipulated further.
//
// Applying the § postfix operator to an existing AttributedString makes a separate copy of it.
//
// This converts a straight Swift string to an AttributedString
//
//    func example() -> AttributedString {
//        let string = "The quick brown fox."
//        let attributedString = string§
//        return attributedString
//    }
//
// This retrieves the NSAttributedString from a UITextView and converts it to an AttributedString
//
//    func example(textView: UITextView) -> AttributedString {
//        let string = textView.attributedText  // This is an NSAttributedString
//        let attributedString = string§        // This is an AttributedString (NSMutableAttributedString)
//        return attributedString
//    }
//
// This performs localization with placeholder replacement using the ¶ operator (see StringExtensions.swift), then uses the § operator to convert the result to an AttributedString.
//
//    func example() -> AttributedString {
//        let followersCount = 20
//        let template = "#{followersCount} followers." ¶ ["followersCount": followersCount]
//        return template§
//    }
//
//    func example() {
//        let s1 = "Hello."§ // Creates an AttributedString
//        s1.foregroundColor = .Red // s1 is now red
//
//        let s2 = s1 // Only copies the reference
//        s2.foregroundColor = .Green // s1 and s2 are now green
//
//        let s3 = s1§ // This performs a true copy of s1
//
//        s3.foregroundColor = .Blue // s1 and s2 are green, s3 is blue.
//    }
//

//
// *** Use Swift String range types with AttributedStrings, not NSRange.
//
// NSRange assumes underlying UTF-16 strings. NSRange instances with arbitrary `location` values may cut into characters that have more than one 16-bit word in their encoding. Swift has a better model for Strings which accounts for all underlying Unicode encodings and the fact that they may have variable-length characters ("extended grapheme clusters"). AttributedString provides additional methods that take Swift String ranges, and which should be used instead of the existing methods that take NSRange instances.
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
// let nsRange = string.nsRange(fromRange: range)
//
// let range = string.range(fromNSRange: nsRage)
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
//    func example(s: AttributedString) {
//        s.remove(attributeNamed: NSFontAttributeName) // removes attribute from entire string
//        let range = s.string.range(start: 0, end: 2)
//        s.remove(attributeNamed: NSFontAttributeName, fromRange: range) // removes attribute from just `range`.
//    }
//

//
// Principle: Attributes are added to AttributedString instances by assignment. Common attributes such as font, foregroundColor, and paragraphStyle can be directly assigned as attributes.
//
//    func example() {
//        let attributedString = "The quick brown fox."§
//        attributedString.font = .boldSystemFontOfSize(18)
//        attributedString.foregroundColor = .Red
//    }
//

//
// *** Attributes of substrings of AttributedString instances are edited together.
//
//    func testString() {
//        let attributedString = "The quick brown fox."§
//        attributedString.font = .systemFontOfSize(18) // Applies to whole string
//        attributedString.foregroundColor = .Gray
//
//        let range = attributedString.string.range(start: 10, end: 15) // "brown"
//        attributedString.edit(inRange: range) { substring in
//            substring.font = .boldSystemFontOfSize(18)
//            substring.foregroundColor = .Red
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
//        attributedString.edit(inRange: range) { substring in
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
//        attributedString.edit(inRange: range1) { substring in
//            substring[key1] = CGFloat(25.5)
//        }
//
//        let range = attributedString.string.range(start: 10, end: 15) // "brown"
//        let key = "link"
//        attributedString.edit(inRange: range) { substring in
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
// Once a template String has been constructed, use String.attributedStringWithTags() to convert it to an AttributedString:
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
//                substring.foregroundColor = .Brown
//            case "action":
//                substring.foregroundColor = .Red
//            case "subject":
//                substring.foregroundColor = .Gray
//            default:
//                // The default clause is called *before* the tag-specific clauses.
//                substring.foregroundColor = .White
//                substring.font = .systemFontOfSize(12)
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
//                    substring.font = .boldSystemFontOfSize(fontSize)
//                    substring.foregroundColor = .Blue
//                default:
//                    substring.font = .systemFontOfSize(fontSize)
//                    substring.foregroundColor = .White
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
public typealias AttributedString = NSMutableAttributedString

postfix operator § { }

public postfix func § (left: String) -> AttributedString {
    return AttributedString(string: left)
}

public postfix func § (left: AttributedString) -> AttributedString {
    return left.mutableCopy() as! AttributedString
}

// swiftlint:disable:next custom_rules
public postfix func § (left: NSAttributedString) -> AttributedString {
    return left.mutableCopy() as! AttributedString
}

// swiftlint:disable:next custom_rules
public func += (left: AttributedString, right: NSAttributedString) {
    left.appendAttributedString(right)
}


extension AttributedString {
    public var count: Int {
        return string.characters.count
    }

    public func attributedSubstring(fromRange range: StringRange) -> AttributedString {
        return attributedSubstringFromRange(string.nsRange(fromRange: range)!)§
    }

    public func attributes(atIndex index: StringIndex, inRange rangeLimit: StringRange? = nil) -> StringAttributes {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(fromRange: rangeLimit) ?? string.nsRange
        let attrs = attributesAtIndex(location, longestEffectiveRange: nil, inRange: nsRangeLimit)
        return attrs
    }

    public func attributesWithRange(atIndex index: StringIndex, inRange rangeLimit: StringRange? = nil) -> (attributes: StringAttributes, longestEffectiveRange: StringRange) {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(fromRange: rangeLimit) ?? string.nsRange
        var nsRange = NSRange()
        let attrs = attributesAtIndex(location, longestEffectiveRange: &nsRange, inRange: nsRangeLimit)
        let range = string.range(fromNSRange: nsRange)!
        return (attrs, range)
    }

    public func attribute(named attrName: String, atIndex index: StringIndex, inRange rangeLimit: StringRange? = nil) -> AnyObject? {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(fromRange: rangeLimit) ?? string.nsRange
        let attr = attribute(attrName, atIndex: location, longestEffectiveRange: nil, inRange: nsRangeLimit)
        return attr
    }

    public func attributeWithRange(named attrName: String, atIndex index: StringIndex, inRange rangeLimit: StringRange? = nil) -> (attribute: AnyObject?, longestEffectiveRange: StringRange) {
        let location = string.location(fromIndex: index)
        let nsRangeLimit = string.nsRange(fromRange: rangeLimit) ?? string.nsRange
        var nsRange = NSRange()
        let attr = attribute(attrName, atIndex: location, longestEffectiveRange: &nsRange, inRange: nsRangeLimit)
        let range = string.range(fromNSRange: nsRange)!
        return (attr, range)
    }

    public func enumerateAttributes(inRange range: StringRange? = nil, options opts: NSAttributedStringEnumerationOptions = [], usingBlock block: (StringAttributes, StringRange, AttributedSubstring) -> Bool) {
        let nsRange = string.nsRange(fromRange: range) ?? string.nsRange
        enumerateAttributesInRange(nsRange, options: opts) { (attrs, nsRange, stop) in
            let range = self.string.range(fromNSRange: nsRange)!
            stop[0] = ObjCBool(block(attrs, range, self.substring(forRange: range)))
        }
    }

    public func enumerateAttribute(named attrName: String, inRange enumerationRange: StringRange? = nil, options opts: NSAttributedStringEnumerationOptions = [], usingBlock block: (AnyObject?, StringRange, AttributedSubstring) -> Bool) {
        let nsEnumerationRange = string.nsRange(fromRange: enumerationRange) ?? string.nsRange
        enumerateAttribute(attrName, inRange: nsEnumerationRange, options: opts) { (value, nsRange, stop) in
            let range = self.string.range(fromNSRange: nsRange)!
            stop[0] = ObjCBool(block(value, range, self.substring(forRange: range)))
        }
    }

    public func replaceCharacters(inRange range: StringRange, withString str: String) {
        let nsRange = string.nsRange(fromRange: range)!
        replaceCharactersInRange(nsRange, withString: str)
    }

    public func set(attributes attrs: StringAttributes?, inRange range: StringRange? = nil) {
        let nsRange = string.nsRange(fromRange: range) ?? string.nsRange
        setAttributes(attrs, range: nsRange)
    }

    public func add(attributeNamed attrName: String, value: AnyObject, toRange range: StringRange? = nil) {
        let nsRange = string.nsRange(fromRange: range) ?? string.nsRange
        addAttribute(attrName, value: value, range: nsRange)
    }

    public func add(attributes attrs: StringAttributes, toRange range: StringRange? = nil) {
        let nsRange = string.nsRange(fromRange: range) ?? string.nsRange
        addAttributes(attrs, range: nsRange)
    }

    public func remove(attributeNamed attrName: String, fromRange range: StringRange? = nil) {
        let nsRange = string.nsRange(fromRange: range) ?? string.nsRange
        removeAttribute(attrName, range: nsRange)
    }

    public func replaceCharacters(inRange range: StringRange, withAttributedString attrString: AttributedString) {
        let nsRange = string.nsRange(fromRange: range)!
        replaceCharactersInRange(nsRange, withAttributedString: attrString)
    }

    public func insert(attributedString attrString: AttributedString, atIndex index: StringIndex) {
        let location = string.location(fromIndex: index)
        insertAttributedString(attrString, atIndex: location)
    }

    public func deleteCharacters(inRange range: StringRange) {
        let nsRange = string.nsRange(fromRange: range)!
        deleteCharactersInRange(nsRange)
    }
}

extension AttributedString {
    public func substring(forRange range: StringRange? = nil) -> AttributedSubstring {
        return AttributedSubstring(string: self, range: range)
    }

    public func substring(fromIndex index: StringIndex) -> AttributedSubstring {
        return AttributedSubstring(string: self, fromIndex: index)
    }

    public func substrings(withTag tag: String) -> [AttributedSubstring] {
        var result = [AttributedSubstring]()

        var index = string.startIndex
        while index < string.endIndex {
            let (attrs, longestEffectiveRange) = attributesWithRange(atIndex: index)
            if attrs[tag] as? Bool == true {
                let substring = AttributedSubstring(string: self, range: longestEffectiveRange)
                result.append(substring)
                index = longestEffectiveRange.endIndex
            }
            index = index.advancedBy(1)
        }

        return result
    }
}

extension AttributedString {
    public var font: UIFont {
        get { return substring().font }
        set { substring().font = newValue }
    }

    public var foregroundColor: UIColor {
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

    public subscript(attribute: String) -> AnyObject? {
        get { return substring()[attribute] }
        set { substring()[attribute] = newValue! }
    }

    public func getString(forTag tag: String, atIndex index: StringIndex) -> String? {
        return substring(fromIndex: index).getString(forTag: tag)
    }

    public func has(tag tag: String, atIndex index: StringIndex) -> Bool {
        return substring(fromIndex: index).has(tag: tag)
    }

    public func edit(f: (AttributedSubstring) -> Void) {
        beginEditing()
        f(substring())
        endEditing()
    }

    public func edit(inRange range: StringRange, f: (AttributedSubstring) -> Void) {
        beginEditing()
        f(substring(forRange: range))
        endEditing()
    }
}

extension AttributedString {
    public func printAttributes() {
        let aliaser = ObjectAliaser()
        for (index, char) in string.characters.enumerate() {
            let strIndex = string.startIndex.advancedBy(index)
            let joiner = Joiner("", "", " ")
            joiner.append(char)
            let attrs = attributes(atIndex: strIndex)
            for(attrName, value) in attrs {
                joiner.append("\(attrName):\(aliaser.name(forObject: value))")
            }
            print(joiner)
        }
    }
}

public class AttributedSubstring {
    public let attrString: AttributedString
    public let strRange: StringRange
    public let nsRange: NSRange

    public init(string attrString: AttributedString, range strRange: StringRange? = nil) {
        self.attrString = attrString
        self.strRange = strRange ?? attrString.string.range
        self.nsRange = attrString.string.nsRange(fromRange: self.strRange)!
    }

    public convenience init(string attrString: AttributedString, fromIndex index: StringIndex) {
        self.init(string: attrString, range: index..<attrString.string.endIndex)
    }

    public convenience init(string attrString: AttributedString) {
        self.init(string: attrString, range: attrString.string.startIndex..<attrString.string.endIndex)
    }

    public var count: Int {
        return strRange.count
    }

    public var attributedSubstring: AttributedString {
        return attrString.attributedSubstring(fromRange: strRange)
    }

    public func attributes(inRange rangeLimit: StringRange? = nil) -> StringAttributes {
        return attrString.attributes(atIndex: strRange.startIndex, inRange: rangeLimit)
    }

    public func attributesWithRange(inRange rangeLimit: StringRange? = nil) -> (attributes: StringAttributes, longestEffectiveRange: StringRange) {
        return attrString.attributesWithRange(atIndex: strRange.startIndex, inRange: rangeLimit)
    }

    public func attribute(named attrName: String, inRange rangeLimit: StringRange? = nil) -> AnyObject? {
        return attrString.attribute(named: attrName, atIndex: strRange.startIndex, inRange: rangeLimit)
    }

    public func attributeWithRange(named attrName: String, inRange rangeLimit: StringRange? = nil) -> (attribute: AnyObject?, longestEffectiveRange: StringRange) {
        return attrString.attributeWithRange(named: attrName, atIndex: strRange.startIndex, inRange: rangeLimit)
    }

    public func enumerateAttributes(options opts: NSAttributedStringEnumerationOptions = [], usingBlock block: (StringAttributes, StringRange, AttributedSubstring) -> Bool) {
        attrString.enumerateAttributes(inRange: strRange, options: opts, usingBlock: block)
    }

    public func enumerateAttribute(named attrName: String, options opts: NSAttributedStringEnumerationOptions = [], usingBlock block: (AnyObject?, StringRange, AttributedSubstring) -> Bool) {
        attrString.enumerateAttribute(named: attrName, inRange: strRange, options: opts, usingBlock: block)
    }

    public func set(attributes attrs: StringAttributes?) {
        attrString.set(attributes: attrs, inRange: strRange)
    }

    public func add(attributeNamed attrName: String, value: AnyObject) {
        attrString.add(attributeNamed: attrName, value: value, toRange: strRange)
    }

    public func add(attributes attrs: StringAttributes) {
        attrString.add(attributes: attrs, toRange: strRange)
    }

    public func remove(attributeNamed attrName: String) {
        attrString.remove(attributeNamed: attrName, fromRange: strRange)
    }
}

extension AttributedSubstring : CustomStringConvertible {
    public var description: String {
        let s = attrString.string.substringWithRange(strRange)
        return "(AttributedSubstring attrString:\(s), strRange:\(strRange))"
    }
}

extension AttributedSubstring {
    public func addTag(tag: String) {
        self[tag] = true
    }

    public func getRange(forTag tag: String) -> StringRange? {
        let (value, longestEffectiveRange) = attributeWithRange(named: tag)
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

    public func has(tag tag: String) -> Bool {
        return getRange(forTag: tag) != nil
    }

    public subscript(attrName: String) -> AnyObject? {
        get {
            return attribute(named: attrName)
        }
        set {
            if let newValue = newValue {
                add(attributeNamed: attrName, value: newValue)
            } else {
                remove(attributeNamed: attrName)
            }
        }
    }

    public var font: UIFont {
        get { return attribute(named: NSFontAttributeName) as? UIFont ?? UIFont.systemFontOfSize(12) }
        set { add(attributeNamed: NSFontAttributeName, value: newValue) }
    }

    public var foregroundColor: UIColor {
        get { return attribute(named: NSForegroundColorAttributeName) as? UIColor ?? .Black }
        set { add(attributeNamed: NSForegroundColorAttributeName, value: newValue) }
    }

    public var paragraphStyle: NSMutableParagraphStyle {
        get {
            if let value = attribute(named: NSParagraphStyleAttributeName) as? NSParagraphStyle {
                return value.mutableCopy() as! NSMutableParagraphStyle
            } else {
                return NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            }
        }
        set { add(attributeNamed: NSParagraphStyleAttributeName, value: newValue) }
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
        get { return has(tag: overrideTintColorTag) }
        set {
            if newValue {
                addTag(overrideTintColorTag)
            } else {
                remove(attributeNamed: overrideTintColorTag)
            }
        }
    }
}

// (?:(?<!\\)#\{(.*?)\|(\w+)\})
// The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}.
private let tagsReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(.*?)\\|(\\w+)\\})"

extension String {
    public init(text: String, tag: String) {
        self.init("#{\(text)|\(tag)}")
    }

    public func attributedStringWithTags(tagEditBlock tagEditBlock: ((tag: String, substring: AttributedSubstring) -> Void)? = nil) -> AttributedString {
        var tags = [String]()

        let matches = tagsReplacementRegex ~?? self
        let replacements = matches.map { match -> RangeReplacement in
            let matchRange = range(fromNSRange: match.range)!

            let textRange = range(fromNSRange: match.rangeAtIndex(1))!
            let tagRange = range(fromNSRange: match.rangeAtIndex(2))!

            let text = self.substringWithRange(textRange)
            let tag = self.substringWithRange(tagRange)

            tags.append(tag)
            return (matchRange, text)
        }

        let (string, replacedRanges) = replacing(replacements: replacements)
        let attributedString = string§

        tagEditBlock?(tag: "", substring: attributedString.substring())

        for (index, tag) in tags.enumerate() {
            let replacedRange = replacedRanges[index]
            attributedString.edit(inRange: replacedRange) { substring in
                substring.addTag(tag)
                tagEditBlock?(tag: tag, substring: substring)
            }
        }

        return attributedString
    }
}
