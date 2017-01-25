//
//  ViewController.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//


import UIKit

extension Log.GroupName {
    public static let viewControllerLifecycle = Log.GroupName("viewControllers")
}

open class ViewController: UIViewController, Skinnable {
    private var _mySkin: Skin?
    public var mySkin: Skin? {
        get { return _mySkin ?? inheritedSkin }
        set { _mySkin = newValue; updateAppearanceContainer(skin: _mySkin) }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _setup()
    }

    private func _setup() {
        logInfo("init \(self)", group: .viewControllerLifecycle)
        setup()
    }

    deinit {
        logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear: \(self)")
        super.viewWillAppear(animated)
        guard let skin = mySkin else { return }
        updateAppearance(skin: skin)
        updateAppearanceContainer(skin: skin)
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return _preferredStatusBarStyle(for: mySkin)
    }

    open func setup() { }
}

extension UIViewController {
    public func _updateAppearance(skin: Skin?) {
        guard let skin = skin else { return }

        print("needsStatustBarUpdate from: \(self)")
        setNeedsStatusBarAppearanceUpdate()

        if isViewLoaded {
            view!.backgroundColor = skin.viewControllerBackgroundColor
        }

        if let navigationController = navigationController {
            if navigationController.isNavigationBarHidden != skin.navigationBarHidden {
                navigationController.setNavigationBarHidden(skin.navigationBarHidden, animated: true)
            }

            let navigationBar = navigationController.navigationBar
            navigationBar.isTranslucent = true
            let image = newImage(withSize: CGSize(width: 16, height: 16), background: skin.navbarBarColor)
            navigationBar.setBackgroundImage(image, for: .default)
            navigationBar.tintColor = skin.navbarTintColor
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: skin.navbarTitleColor]

            if let toolbar = navigationController.toolbar {
                toolbar.isTranslucent = true
                let image = newImage(withSize: CGSize(width: 16, height: 16), background: skin.toolbarColor)
                toolbar.setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
                toolbar.tintColor = skin.toolbarTintColor
            }
        }
    }

    public func _preferredStatusBarStyle(for skin: Skin?) -> UIStatusBarStyle {
        let style = skin?.statusBarStyle ?? .default
        print("style: \(style.rawValue) for \(self)")
        return style
    }
}
