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
    var pageIndicatorTintColor: UIColor { get }
    var currentPageIndicatorTintColor: UIColor { get }
    var viewControllerBackgroundColor: UIColor { get }
    var navigationBarBackgroundColor: UIColor { get }
    var navigationBarForegroundColor: UIColor { get }
    var toolbarBackgroundColor: UIColor { get }
    var toolbarForegroundColor: UIColor { get }
}

open class DefaultSkin: Skin {
    public init() { }

    open var pageIndicatorTintColor: UIColor { return UIColor(white: 0.0, alpha: 0.3) }
    open var currentPageIndicatorTintColor: UIColor { return .black }
    open var viewControllerBackgroundColor: UIColor { return .white }
    open var navigationBarBackgroundColor: UIColor { return .gray }
    open var navigationBarForegroundColor: UIColor { return .white }
    open var toolbarBackgroundColor: UIColor { return .green }
    open var toolbarForegroundColor: UIColor { return .yellow }
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

    public func blend(from color1: UIColor, to color2: UIColor, at frac: Frac) -> UIColor {
        return WolfCore.blend(from: color1 |> Color.init, to: color2 |> Color.init, at: frac) |> UIColor.init
    }

    open lazy var pageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.pageIndicatorTintColor, to: self.skin2.pageIndicatorTintColor, at: self.frac) }()
    open lazy var currentPageIndicatorTintColor: UIColor = { return self.blend(from: self.skin1.currentPageIndicatorTintColor, to: self.skin2.currentPageIndicatorTintColor, at: self.frac) }()
    open lazy var viewControllerBackgroundColor: UIColor = { return self.blend(from: self.skin1.viewControllerBackgroundColor, to: self.skin2.viewControllerBackgroundColor, at: self.frac) }()
    open lazy var navigationBarBackgroundColor: UIColor = { return self.blend(from: self.skin1.navigationBarBackgroundColor, to: self.skin2.navigationBarBackgroundColor, at: self.frac) }()
    open lazy var navigationBarForegroundColor: UIColor = { return self.blend(from: self.skin1.navigationBarForegroundColor, to: self.skin2.navigationBarForegroundColor, at: self.frac) }()
    open lazy var toolbarBackgroundColor: UIColor = { return self.blend(from: self.skin1.toolbarBackgroundColor, to: self.skin2.toolbarBackgroundColor, at: self.frac) }()
    open lazy var toolbarForegroundColor: UIColor = { return self.blend(from: self.skin1.toolbarForegroundColor, to: self.skin2.toolbarForegroundColor, at: self.frac) }()
}

public var skin: Skin? {
    didSet {
        postSkinChangedNotification()
    }
}
