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
    open var navigationBarBackgroundColor: UIColor { return .blue }
    open var navigationBarForegroundColor: UIColor { return .yellow }
    open var toolbarBackgroundColor: UIColor { return .green }
    open var toolbarForegroundColor: UIColor { return .yellow }
}

public var skin: Skin? {
    didSet {
        postSkinChangedNotification()
    }
}
