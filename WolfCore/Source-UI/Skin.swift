//
//  Skin.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/3/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

extension Log.GroupName {
    public static let skin = Log.GroupName("skin")
}

public struct FontStyle {
    public let descriptor: UIFontDescriptor
    public let color: UIColor?
    public let allCaps: Bool

    public var font: UIFont {
        return UIFont(descriptor: descriptor, size: 0)
    }

    public var attributes: [String: Any] {
        var a = [String: Any]()
        a[NSFontAttributeName] = font
        if let color = color {
            a[NSForegroundColorAttributeName] = color
        }
        return a
    }

    public init(descriptor: UIFontDescriptor, color: UIColor? = nil, allCaps: Bool = false) {
        self.descriptor = descriptor
        self.color = color
        self.allCaps = allCaps
    }

    public init(family: String, face: String? = nil, size: CGFloat, color: UIColor? = nil, allCaps: Bool = false) {
        var descriptor = UIFontDescriptor().withFamily(family).withSize(size)
        if let face = face {
            descriptor = descriptor.withFace(face)
        }
        self.init(descriptor: descriptor, color: color, allCaps: allCaps)
    }

    public func apply(to string: String?) -> AString? {
        guard var string = string else { return nil }
        string = allCaps ? (string.uppercased()) : string
        let aString = string§
        aString.setAttributes(attributes)
        return aString
    }
}

public struct FontStyleName: ExtensibleEnumeratedName {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    // Hashable
    public var hashValue: Int { return name.hashValue }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    public var rawValue: String { return name }
}

extension FontStyleName {
    public static let display = FontStyleName("display")
    public static let title = FontStyleName("title")
    public static let book = FontStyleName("book")
}

public typealias FontStyles = [FontStyleName: FontStyle]

public protocol Skin {
    var statusBarStyle: UIStatusBarStyle { get }
    var navigationBarHidden: Bool { get }

    var viewControllerBackgroundColor: UIColor { get }
    var textColor: UIColor { get }

    var navbarBarColor: UIColor { get }
    var navbarTitleColor: UIColor { get }
    var navbarTintColor: UIColor { get }

    var toolbarColor: UIColor { get }
    var toolbarItemColor: UIColor { get }
    var toolbarTintColor: UIColor { get }

    var currentPageIndicatorTintColor: UIColor { get }
    var pageIndicatorTintColor: UIColor { get }

    var fontStyles: FontStyles { get }
}

extension Skin {
    public func fontStyleNamed(_ name: String?) -> FontStyle? {
        guard let name = name else { return nil }
        return fontStyles[FontStyleName(name)]
    }
}

open class DefaultSkin: Skin {
    public init() { }

    open var statusBarStyle: UIStatusBarStyle { return .default }
    open var navigationBarHidden: Bool { return false }

    open var viewControllerBackgroundColor: UIColor { return .white }
    open var textColor: UIColor { return .black }

    open var navbarBarColor: UIColor { return UIColor.gray.withAlphaComponent(0.3) }
    open var navbarTitleColor: UIColor { return .black }
    open var navbarTintColor: UIColor { return defaultTintColor }

    open var toolbarColor: UIColor { return navbarBarColor }
    open var toolbarItemColor: UIColor { return navbarTitleColor }
    open var toolbarTintColor: UIColor { return navbarTintColor }

    open var currentPageIndicatorTintColor: UIColor { return .black }
    open var pageIndicatorTintColor: UIColor { return currentPageIndicatorTintColor.withAlphaComponent(0.3) }

    public var fontStyles: FontStyles = [
        .display: FontStyle(family: "Zapfino", size: 48.0),
        .title: FontStyle(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)),
        .book: FontStyle(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body))
    ]
}

open class DefaultDarkSkin: DefaultSkin {
    override open var statusBarStyle: UIStatusBarStyle { return .lightContent }

    override open var viewControllerBackgroundColor: UIColor { return .black }
    override open var textColor: UIColor { return .white }

    override open var navbarTitleColor: UIColor { return .white }

    override open var currentPageIndicatorTintColor: UIColor { return .white }
}

open class InterpolateSkin: Skin {
    public let skin1: Skin
    public let skin2: Skin
    public let frac: Frac

    public init(skin1: Skin, skin2: Skin, frac: Frac) {
        self.skin1 = skin1
        self.skin2 = skin2
        self.frac = frac
    }

    public func blend(from color1: UIColor, to color2: UIColor) -> UIColor {
        return WolfCore.blend(from: color1 |> Color.init, to: color2 |> Color.init, at: frac) |> UIColor.init
    }

    public func blend<T>(from a: T, to b: T) -> T {
        return frac < 0.5 ? a : b
    }

    open lazy var statusBarStyle: UIStatusBarStyle = { return self.blend(from: self.skin1.statusBarStyle, to: self.skin2.statusBarStyle) }()
    open lazy var navigationBarHidden: Bool = { return self.blend(from: self.skin1.navigationBarHidden, to: self.skin2.navigationBarHidden) }()

    open lazy var viewControllerBackgroundColor: UIColor = { return self.blend(from: self.skin1.viewControllerBackgroundColor, to: self.skin2.viewControllerBackgroundColor) }()
    open lazy var textColor: UIColor = { return self.blend(from: self.skin1.textColor, to: self.skin2.textColor) }()

    open lazy var navbarBarColor: UIColor = { return self.blend(from: self.skin1.navbarBarColor, to: self.skin2.navbarBarColor) }()
    open lazy var navbarTitleColor: UIColor = { return self.blend(from: self.skin1.navbarTitleColor, to: self.skin2.navbarTitleColor) }()
    open lazy var navbarTintColor: UIColor = { return self.blend(from: self.skin1.navbarTintColor, to: self.skin2.navbarTintColor) }()

    open lazy var toolbarColor: UIColor = { return self.blend(from: self.skin1.toolbarColor, to: self.skin2.toolbarColor) }()
    open lazy var toolbarItemColor: UIColor = { return self.blend(from: self.skin1.toolbarItemColor, to: self.skin2.toolbarItemColor) }()
    open lazy var toolbarTintColor: UIColor = { return self.blend(from: self.skin1.toolbarTintColor, to: self.skin2.toolbarTintColor) }()

    open lazy var currentPageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.currentPageIndicatorTintColor, to: self.skin2.currentPageIndicatorTintColor) }()
    open lazy var pageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.pageIndicatorTintColor, to: self.skin2.pageIndicatorTintColor) }()

    public var fontStyles: FontStyles { return self.skin1.fontStyles }
}

public var skin: Skin? {
    didSet {
        postSkinChangedNotification()
    }
}

/*
 As of iOS 10.2, generated by printFontNames()

 Copperplate
	Copperplate-Light
	Copperplate
	Copperplate-Bold

 Heiti SC

 Apple SD Gothic Neo
	AppleSDGothicNeo-Thin
	AppleSDGothicNeo-Light
	AppleSDGothicNeo-Regular
	AppleSDGothicNeo-Bold
	AppleSDGothicNeo-SemiBold
	AppleSDGothicNeo-UltraLight
	AppleSDGothicNeo-Medium

 Thonburi
	Thonburi
	Thonburi-Light
	Thonburi-Bold

 Gill Sans
	GillSans-Italic
	GillSans-SemiBold
	GillSans-UltraBold
	GillSans-Light
	GillSans-Bold
	GillSans
	GillSans-SemiBoldItalic
	GillSans-BoldItalic
	GillSans-LightItalic

 Marker Felt
	MarkerFelt-Thin
	MarkerFelt-Wide

 Courier New
	CourierNewPS-ItalicMT
	CourierNewPSMT
	CourierNewPS-BoldItalicMT
	CourierNewPS-BoldMT

 Kohinoor Telugu
	KohinoorTelugu-Regular
	KohinoorTelugu-Medium
	KohinoorTelugu-Light

 Heiti TC

 Avenir Next Condensed
	AvenirNextCondensed-Heavy
	AvenirNextCondensed-MediumItalic
	AvenirNextCondensed-Regular
	AvenirNextCondensed-UltraLightItalic
	AvenirNextCondensed-Medium
	AvenirNextCondensed-HeavyItalic
	AvenirNextCondensed-DemiBoldItalic
	AvenirNextCondensed-Bold
	AvenirNextCondensed-DemiBold
	AvenirNextCondensed-BoldItalic
	AvenirNextCondensed-Italic
	AvenirNextCondensed-UltraLight

 Tamil Sangam MN
	TamilSangamMN
	TamilSangamMN-Bold

 Helvetica Neue
	HelveticaNeue-UltraLightItalic
	HelveticaNeue-Medium
	HelveticaNeue-MediumItalic
	HelveticaNeue-UltraLight
	HelveticaNeue-Italic
	HelveticaNeue-Light
	HelveticaNeue-ThinItalic
	HelveticaNeue-LightItalic
	HelveticaNeue-Bold
	HelveticaNeue-Thin
	HelveticaNeue-CondensedBlack
	HelveticaNeue
	HelveticaNeue-CondensedBold
	HelveticaNeue-BoldItalic

 Gurmukhi MN
	GurmukhiMN-Bold
	GurmukhiMN

 Georgia
	Georgia-BoldItalic
	Georgia-Italic
	Georgia
	Georgia-Bold

 Times New Roman
	TimesNewRomanPS-ItalicMT
	TimesNewRomanPS-BoldItalicMT
	TimesNewRomanPS-BoldMT
	TimesNewRomanPSMT

 Sinhala Sangam MN
	SinhalaSangamMN-Bold
	SinhalaSangamMN

 Arial Rounded MT Bold
	ArialRoundedMTBold

 Kailasa
	Kailasa-Bold
	Kailasa

 Kohinoor Devanagari
	KohinoorDevanagari-Regular
	KohinoorDevanagari-Light
	KohinoorDevanagari-Semibold

 Kohinoor Bangla
	KohinoorBangla-Regular
	KohinoorBangla-Semibold
	KohinoorBangla-Light

 Chalkboard SE
	ChalkboardSE-Bold
	ChalkboardSE-Light
	ChalkboardSE-Regular

 Apple Color Emoji
	AppleColorEmoji

 PingFang TC
	PingFangTC-Regular
	PingFangTC-Thin
	PingFangTC-Medium
	PingFangTC-Semibold
	PingFangTC-Light
	PingFangTC-Ultralight

 Gujarati Sangam MN
	GujaratiSangamMN
	GujaratiSangamMN-Bold

 Geeza Pro
	GeezaPro-Bold
	GeezaPro

 Damascus
	DamascusBold
	DamascusLight
	Damascus
	DamascusMedium
	DamascusSemiBold

 Noteworthy
	Noteworthy-Bold
	Noteworthy-Light

 Avenir
	Avenir-Oblique
	Avenir-HeavyOblique
	Avenir-Heavy
	Avenir-BlackOblique
	Avenir-BookOblique
	Avenir-Roman
	Avenir-Medium
	Avenir-Black
	Avenir-Light
	Avenir-MediumOblique
	Avenir-Book
	Avenir-LightOblique

 Mishafi
	DiwanMishafi

 Academy Engraved LET
	AcademyEngravedLetPlain

 Futura
	Futura-CondensedExtraBold
	Futura-Medium
	Futura-Bold
	Futura-CondensedMedium
	Futura-MediumItalic

 Party LET
	PartyLetPlain

 Kannada Sangam MN
	KannadaSangamMN-Bold
	KannadaSangamMN

 Arial Hebrew
	ArialHebrew-Bold
	ArialHebrew-Light
	ArialHebrew

 Farah
	Farah

 Arial
	Arial-BoldMT
	Arial-BoldItalicMT
	Arial-ItalicMT
	ArialMT

 Chalkduster
	Chalkduster

 Hoefler Text
	HoeflerText-Italic
	HoeflerText-Black
	HoeflerText-Regular
	HoeflerText-BlackItalic

 Optima
	Optima-ExtraBlack
	Optima-BoldItalic
	Optima-Italic
	Optima-Regular
	Optima-Bold

 Palatino
	Palatino-Italic
	Palatino-Roman
	Palatino-BoldItalic
	Palatino-Bold

 Malayalam Sangam MN
	MalayalamSangamMN-Bold
	MalayalamSangamMN

 Al Nile
	AlNile
	AlNile-Bold

 Lao Sangam MN
	LaoSangamMN

 Bradley Hand
	BradleyHandITCTT-Bold

 Hiragino Mincho ProN
	HiraMinProN-W3
	HiraMinProN-W6

 PingFang HK
	PingFangHK-Medium
	PingFangHK-Thin
	PingFangHK-Regular
	PingFangHK-Ultralight
	PingFangHK-Semibold
	PingFangHK-Light

 Helvetica
	Helvetica-Oblique
	Helvetica-BoldOblique
	Helvetica
	Helvetica-Light
	Helvetica-Bold
	Helvetica-LightOblique

 Courier
	Courier-BoldOblique
	Courier-Oblique
	Courier
	Courier-Bold

 Cochin
	Cochin-Italic
	Cochin-Bold
	Cochin
	Cochin-BoldItalic

 Trebuchet MS
	TrebuchetMS-Bold
	TrebuchetMS-Italic
	Trebuchet-BoldItalic
	TrebuchetMS

 Devanagari Sangam MN
	DevanagariSangamMN
	DevanagariSangamMN-Bold

 Oriya Sangam MN
	OriyaSangamMN
	OriyaSangamMN-Bold

 Snell Roundhand
	SnellRoundhand
	SnellRoundhand-Bold
	SnellRoundhand-Black

 Zapf Dingbats
	ZapfDingbatsITC

 Bodoni 72
	BodoniSvtyTwoITCTT-Bold
	BodoniSvtyTwoITCTT-BookIta
	BodoniSvtyTwoITCTT-Book

 Verdana
	Verdana-Italic
	Verdana
	Verdana-Bold
	Verdana-BoldItalic

 American Typewriter
	AmericanTypewriter-CondensedBold
	AmericanTypewriter-Condensed
	AmericanTypewriter-CondensedLight
	AmericanTypewriter
	AmericanTypewriter-Bold
	AmericanTypewriter-Semibold
	AmericanTypewriter-Light

 Avenir Next
	AvenirNext-Medium
	AvenirNext-DemiBoldItalic
	AvenirNext-DemiBold
	AvenirNext-HeavyItalic
	AvenirNext-Regular
	AvenirNext-Italic
	AvenirNext-MediumItalic
	AvenirNext-UltraLightItalic
	AvenirNext-BoldItalic
	AvenirNext-Heavy
	AvenirNext-Bold
	AvenirNext-UltraLight

 Baskerville
	Baskerville-SemiBoldItalic
	Baskerville-SemiBold
	Baskerville-BoldItalic
	Baskerville
	Baskerville-Bold
	Baskerville-Italic

 Khmer Sangam MN
	KhmerSangamMN

 Didot
	Didot-Bold
	Didot
	Didot-Italic

 Savoye LET
	SavoyeLetPlain

 Bodoni Ornaments
	BodoniOrnamentsITCTT

 Symbol
	Symbol

 Menlo
	Menlo-BoldItalic
	Menlo-Bold
	Menlo-Italic
	Menlo-Regular

 Bodoni 72 Smallcaps
	BodoniSvtyTwoSCITCTT-Book

 Papyrus
	Papyrus-Condensed
	Papyrus

 Hiragino Sans
	HiraginoSans-W3
	HiraginoSans-W6

 PingFang SC
	PingFangSC-Medium
	PingFangSC-Semibold
	PingFangSC-Light
	PingFangSC-Ultralight
	PingFangSC-Regular
	PingFangSC-Thin

 Myanmar Sangam MN
	MyanmarSangamMN
	MyanmarSangamMN-Bold

 Zapfino
	Zapfino

 Telugu Sangam MN

 Bodoni 72 Oldstyle
	BodoniSvtyTwoOSITCTT-BookIt
	BodoniSvtyTwoOSITCTT-Book
	BodoniSvtyTwoOSITCTT-Bold

 Euphemia UCAS
	EuphemiaUCAS
	EuphemiaUCAS-Italic
	EuphemiaUCAS-Bold
 
 Bangla Sangam MN
 
 */
