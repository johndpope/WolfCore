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

public protocol Skin {
    var statusBarStyle: UIStatusBarStyle { get }
    var navigationBarHidden: Bool { get }

    var viewControllerBackgroundColor: UIColor { get }
    var labelTextColor: UIColor { get }

    var navbarBarColor: UIColor { get }
    var navbarTitleColor: UIColor { get }
    var navbarTintColor: UIColor { get }

    var toolbarColor: UIColor { get }
    var toolbarItemColor: UIColor { get }
    var toolbarTintColor: UIColor { get }

    var currentPageIndicatorTintColor: UIColor { get }
    var pageIndicatorTintColor: UIColor { get }
}

open class DefaultSkin: Skin {
    public init() { }

    open var statusBarStyle: UIStatusBarStyle { return .default }
    open var navigationBarHidden: Bool { return false }

    open var viewControllerBackgroundColor: UIColor { return .white }
    open var labelTextColor: UIColor { return .black }

    open var navbarBarColor: UIColor { return UIColor.gray.withAlphaComponent(0.3) }
    open var navbarTitleColor: UIColor { return .black }
    open var navbarTintColor: UIColor { return defaultTintColor }

    open var toolbarColor: UIColor { return navbarBarColor }
    open var toolbarItemColor: UIColor { return navbarTitleColor }
    open var toolbarTintColor: UIColor { return navbarTintColor }

    open var currentPageIndicatorTintColor: UIColor { return .black }
    open var pageIndicatorTintColor: UIColor { return currentPageIndicatorTintColor.withAlphaComponent(0.3) }
}

open class DefaultDarkSkin: DefaultSkin {
    override open var statusBarStyle: UIStatusBarStyle { return .lightContent }

    override open var viewControllerBackgroundColor: UIColor { return .black }
    override open var labelTextColor: UIColor { return .white }

//    override open var navbarBarColor: UIColor { return UIColor.gray.withAlphaComponent(0.4) }
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
    open lazy var labelTextColor: UIColor = { return self.blend(from: self.skin1.labelTextColor, to: self.skin2.labelTextColor) }()

    open lazy var navbarBarColor: UIColor = { return self.blend(from: self.skin1.navbarBarColor, to: self.skin2.navbarBarColor) }()
    open lazy var navbarTitleColor: UIColor = { return self.blend(from: self.skin1.navbarTitleColor, to: self.skin2.navbarTitleColor) }()
    open lazy var navbarTintColor: UIColor = { return self.blend(from: self.skin1.navbarTintColor, to: self.skin2.navbarTintColor) }()

    open lazy var toolbarColor: UIColor = { return self.blend(from: self.skin1.toolbarColor, to: self.skin2.toolbarColor) }()
    open lazy var toolbarItemColor: UIColor = { return self.blend(from: self.skin1.toolbarItemColor, to: self.skin2.toolbarItemColor) }()
    open lazy var toolbarTintColor: UIColor = { return self.blend(from: self.skin1.toolbarTintColor, to: self.skin2.toolbarTintColor) }()

    open lazy var currentPageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.currentPageIndicatorTintColor, to: self.skin2.currentPageIndicatorTintColor) }()
    open lazy var pageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.pageIndicatorTintColor, to: self.skin2.pageIndicatorTintColor) }()
}

public var skin: Skin? {
    didSet {
        postSkinChangedNotification()
    }
}
