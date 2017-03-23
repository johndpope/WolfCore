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
    public static let statusBar = Log.GroupName("statusBar")
}

public protocol Skin {
    var id: UUID { get }

    var statusBarStyle: UIStatusBarStyle { get }
    var navigationBarHidden: Bool { get }

    var viewControllerBackgroundColor: UIColor { get }
    var viewControllerTintColor: UIColor { get }
    var viewControllerHighlightedTintColor: UIColor { get }

    var buttonTintColor: UIColor { get }
    var buttonHighlightedTintColor: UIColor { get }
    var buttonDisabledColor: UIColor { get }
    var buttonFontStyleName: FontStyleName { get }

    var textColor: UIColor { get }

    var navbarBarColor: UIColor { get }
    var navbarTitleColor: UIColor { get }
    var navbarTintColor: UIColor { get }

    var toolbarBarColor: UIColor { get }
    var toolbarItemColor: UIColor { get }
    var toolbarTintColor: UIColor { get }

    var segbarBarColor: UIColor { get }
    var segbarItemColor: UIColor { get }
    var segbarTintColor: UIColor { get }

    var currentPageIndicatorTintColor: UIColor { get }
    var pageIndicatorTintColor: UIColor { get }

    var textFieldIconTintColor: UIColor { get }

    var fontStyles: FontStyles { get }

    var sliderThumbColor: UIColor { get }
    var sliderMinTrackColor: UIColor { get }
    var sliderMaxTrackColor: UIColor { get }

    func interpolated(to skin: Skin, at frac: Frac) -> Skin
}

extension Skin {
    public func fontStyleNamed(_ name: String?) -> FontStyle? {
        guard let name = FontStyleName(name) else { return nil }
        return fontStyles[name]
    }
}

extension FontFamilyName {
    public static let zapfino = FontFamilyName("Zapfino")
}

open class DefaultSkin: Skin {
    public let id = UUID()

    public init() {}

    open var statusBarStyle: UIStatusBarStyle { return .default }
    open var navigationBarHidden: Bool { return false }

    open var viewControllerBackgroundColor: UIColor { return .white }
    open var viewControllerTintColor: UIColor { return defaultTintColor }
    open var viewControllerHighlightedTintColor: UIColor { return viewControllerTintColor.lightened(by: 0.5) }

    open var buttonTintColor: UIColor { return viewControllerTintColor }
    open var buttonHighlightedTintColor: UIColor { return viewControllerHighlightedTintColor }
    open var buttonDisabledColor: UIColor { return UIColor.gray.withAlphaComponent(0.3) }
    open var buttonFontStyleName: FontStyleName { return .buttonTitle }

    open var textColor: UIColor { return .black }

    open var navbarBarColor: UIColor { return UIColor.gray.withAlphaComponent(0.3) }
    open var navbarTitleColor: UIColor { return .black }
    open var navbarTintColor: UIColor { return defaultTintColor }

    open var toolbarBarColor: UIColor { return navbarBarColor }
    open var toolbarItemColor: UIColor { return navbarTitleColor }
    open var toolbarTintColor: UIColor { return navbarTintColor }

    open var segbarBarColor: UIColor { return navbarBarColor }
    open var segbarItemColor: UIColor { return navbarTitleColor }
    open var segbarTintColor: UIColor { return navbarTintColor }

    open var currentPageIndicatorTintColor: UIColor { return .black }
    open var pageIndicatorTintColor: UIColor { return currentPageIndicatorTintColor.withAlphaComponent(0.3) }

    open var textFieldIconTintColor: UIColor { return defaultTintColor }

    open var sliderThumbColor: UIColor { return defaultTintColor }
    open var sliderMinTrackColor: UIColor { return .lightGray }
    open var sliderMaxTrackColor: UIColor { return .darkGray }

    public var fontStyles: FontStyles = [
        .display: FontStyle(family: .zapfino, size: 48.0),
        .title: FontStyle(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)),
        .book: FontStyle(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)),

        .navbarTitle: FontStyle(font: .boldSystemFont(ofSize: 16)),
        .barbuttonTitle: FontStyle(font: .systemFont(ofSize: 16)),
        .buttonTitle: FontStyle(font: .systemFont(ofSize: 12)),

        .textFieldContent: FontStyle(font: .systemFont(ofSize: 12), color: .black),
        .textFieldPlaceholder: FontStyle(font: .systemFont(ofSize: 12), color: .gray),
        .textFieldCounter: FontStyle(font: .italicSystemFont(ofSize: 8), color: .darkGray),
    ]

    open func interpolated(to skin: Skin, at frac: Frac) -> Skin {
        return InterpolateSkin(skin1: self, skin2: skin, frac: frac)
    }
}

open class DefaultDarkSkin: DefaultSkin {
    override open var statusBarStyle: UIStatusBarStyle { return .lightContent }

    override open var viewControllerBackgroundColor: UIColor { return .black }
    override open var textColor: UIColor { return .white }

    override open var navbarTitleColor: UIColor { return .white }

    override open var currentPageIndicatorTintColor: UIColor { return .white }
}

open class InterpolateSkin: Skin {
    public let id = UUID()

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

    open lazy var statusBarStyle: UIStatusBarStyle = { return self.frac.ledge(self.skin1.statusBarStyle, self.skin2.statusBarStyle) }()
    open lazy var navigationBarHidden: Bool = { return self.frac.ledge(self.skin1.navigationBarHidden, self.skin2.navigationBarHidden) }()

    open lazy var viewControllerBackgroundColor: UIColor = { return self.blend(from: self.skin1.viewControllerBackgroundColor, to: self.skin2.viewControllerBackgroundColor) }()
    open lazy var viewControllerTintColor: UIColor = { return self.blend(from: self.skin1.viewControllerTintColor, to: self.skin2.viewControllerTintColor) }()
    open lazy var viewControllerHighlightedTintColor: UIColor = { return self.blend(from: self.skin1.viewControllerHighlightedTintColor, to: self.skin2.viewControllerHighlightedTintColor) }()

    open lazy var buttonTintColor: UIColor = { return self.blend(from: self.skin1.buttonTintColor, to: self.skin2.buttonTintColor) }()
    open lazy var buttonHighlightedTintColor: UIColor = { return self.blend(from: self.skin1.buttonHighlightedTintColor, to: self.skin2.buttonHighlightedTintColor) }()
    open lazy var buttonDisabledColor: UIColor = { return self.frac.ledge(self.skin1.buttonDisabledColor, self.skin2.buttonDisabledColor) }()

    open lazy var buttonFontStyleName: FontStyleName = { return self.frac.ledge(self.skin1.buttonFontStyleName, self.skin2.buttonFontStyleName) }()

    open lazy var textColor: UIColor = { return self.blend(from: self.skin1.textColor, to: self.skin2.textColor) }()

    open lazy var navbarBarColor: UIColor = { return self.blend(from: self.skin1.navbarBarColor, to: self.skin2.navbarBarColor) }()
    open lazy var navbarTitleColor: UIColor = { return self.blend(from: self.skin1.navbarTitleColor, to: self.skin2.navbarTitleColor) }()
    open lazy var navbarTintColor: UIColor = { return self.blend(from: self.skin1.navbarTintColor, to: self.skin2.navbarTintColor) }()

    open lazy var toolbarBarColor: UIColor = { return self.blend(from: self.skin1.toolbarBarColor, to: self.skin2.toolbarBarColor) }()
    open lazy var toolbarItemColor: UIColor = { return self.blend(from: self.skin1.toolbarItemColor, to: self.skin2.toolbarItemColor) }()
    open lazy var toolbarTintColor: UIColor = { return self.blend(from: self.skin1.toolbarTintColor, to: self.skin2.toolbarTintColor) }()

    open lazy var segbarBarColor: UIColor = { return self.blend(from: self.skin1.segbarBarColor, to: self.skin2.segbarBarColor) }()
    open lazy var segbarItemColor: UIColor = { return self.blend(from: self.skin1.segbarItemColor, to: self.skin2.segbarItemColor) }()
    open lazy var segbarTintColor: UIColor = { return self.blend(from: self.skin1.segbarTintColor, to: self.skin2.segbarTintColor) }()

    open lazy var currentPageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.currentPageIndicatorTintColor, to: self.skin2.currentPageIndicatorTintColor) }()
    open lazy var pageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.pageIndicatorTintColor, to: self.skin2.pageIndicatorTintColor) }()

    open lazy var textFieldIconTintColor: UIColor = { return self.blend(from: self.skin1.textFieldIconTintColor, to: self.skin2.textFieldIconTintColor) }()

    open lazy var sliderThumbColor: UIColor = { return self.blend(from: self.skin1.sliderThumbColor, to: self.skin2.sliderThumbColor) }()
    open lazy var sliderMinTrackColor: UIColor = { return self.blend(from: self.skin1.sliderMinTrackColor, to: self.skin2.sliderMinTrackColor) }()
    open lazy var sliderMaxTrackColor: UIColor = { return self.blend(from: self.skin1.sliderMaxTrackColor, to: self.skin2.sliderMaxTrackColor) }()

    public var fontStyles: FontStyles { return self.skin1.fontStyles }

    open func interpolated(to skin: Skin, at frac: Frac) -> Skin {
        return InterpolateSkin(skin1: self, skin2: skin, frac: frac)
    }
}
