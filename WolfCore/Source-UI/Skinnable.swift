//
//  Skinnable.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public protocol Skinnable: UIAppearanceContainer {
    //func updateAppearance()
    func setupSkinnable()
    var mySkin: Skin? { get set }
    var skinChangedAction: SkinChangedAction! { get set }
    var currentSkin: Skin? { get }
}

extension Skinnable {
    public func setupSkinnable() {
        skinChangedAction = SkinChangedAction(for: self)
    }
}

extension Skinnable where Self: UIView {
    public var currentSkin: Skin? {
        return mySkin ?? (superview as? Skinnable)?.currentSkin ?? skin
    }
}

extension Skinnable where Self: UIViewController {
    public var currentSkin: Skin? {
        return mySkin ?? (parent as? Skinnable)?.currentSkin ?? skin
    }
}

extension Skinnable {
    public func updateAppearance() {
        guard let skin = self.currentSkin else { return }
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [type(of: self)])
        appearance.pageIndicatorTintColor = skin.pageIndicatorTintColor
        appearance.currentPageIndicatorTintColor = skin.currentPageIndicatorTintColor

        guard let vc = self as? ViewController else { return }
        if vc.isViewLoaded {
            vc.view!.backgroundColor = skin.viewControllerBackgroundColor
        }
        vcStyle: if let navigationController = vc.navigationController {
            let navigationBar = navigationController.navigationBar
            navigationBar.barTintColor = skin.navigationBarBackgroundColor
            navigationBar.tintColor = skin.navigationBarForegroundColor

            guard let toolbar = navigationController.toolbar else { break vcStyle }
            toolbar.barTintColor = skin.toolbarBackgroundColor
            toolbar.tintColor = skin.toolbarForegroundColor
        }
    }
}
