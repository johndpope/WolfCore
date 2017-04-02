//
//  ViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//


import UIKit

public typealias ViewControllerBlock = (UIViewController) -> Void

extension Log.GroupName {
    public static let viewControllerLifecycle = Log.GroupName("viewControllers")
}

open class ViewController: UIViewController, Skinnable {
    open var navigationItemTitleView: UIView? { return nil }

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
        //logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.debugIdentifier = "\(typeName(of: self)).view"
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewWillAppear(_ animated: Bool) {
        logTrace("viewWillAppear", obj: self, group: .statusBar)
        super.viewWillAppear(animated)
        if navigationItem.titleView == nil {
            if let navigationItemTitleView = navigationItemTitleView {
                navigationItem.titleView = navigationItemTitleView
            }
        }
        propagateSkin(why: "viewWillAppear")
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
//        if navigxationItem.titleView !== navigationItemTitleView {
//            navigationItem.titleView = navigationItemTitleView
//        }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return _preferredStatusBarStyle(for: skin)
    }

    open func setup() { }
}

extension UIViewController {
    public func _updateAppearance(skin: Skin?) {
        guard let skin = skin else { return }

        logTrace("updateAppearance \(shortName(of: skin))", obj: self, group: .statusBar)
        setNeedsStatusBarAppearanceUpdate()

        if isViewLoaded {
            view!.backgroundColor = skin.viewControllerBackgroundColor
            view!.tintColor = skin.viewControllerTintColor

            if let navigationController = self as? UINavigationController {
                var skin = skin
                if let c = navigationController.childViewControllerForStatusBarStyle {
                    skin = c.skin
                }

                if navigationController.isNavigationBarHidden != skin.navigationBarHidden {
                    navigationController.setNavigationBarHidden(skin.navigationBarHidden, animated: true)
                }

                let navigationBar = navigationController.navigationBar
                navigationBar.isTranslucent = true
                logTrace("navbarBarColor: \(skin.navbarBarColor) from: \(shortName(of: skin))", obj: self, group: .statusBar)
                let image = newImage(withSize: CGSize(width: 16, height: 16), background: skin.navbarBarColor)
                navigationBar.setBackgroundImage(image, for: .default)
                navigationBar.tintColor = skin.navbarTintColor
                navigationBar.titleTextAttributes = [
                    NSFontAttributeName: skin.fontStyles[.navbarTitle]!.font,
                    NSForegroundColorAttributeName: skin.navbarTitleColor
                ]

                // Remove bottom bevel
                navigationBar.shadowImage = UIImage()

                if let toolbar = navigationController.toolbar {
                    toolbar.isTranslucent = true
                    let image = newImage(withSize: CGSize(width: 16, height: 16), background: skin.toolbarBarColor)
                    toolbar.setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
                    toolbar.tintColor = skin.toolbarTintColor
                }
            }

            if let tabBarController = self as? UITabBarController {
                let tabBar = tabBarController.tabBar
                tabBar.isTranslucent = true
                let image = newImage(withSize: CGSize(width: 16, height: 16), background: skin.toolbarBarColor)
                tabBar.backgroundImage = image
                if let items = tabBar.items {
                    for item in items {
                        if let image = item.image {
                            item.image = image.tinted(withColor: skin.toolbarItemColor)
                            item.selectedImage = image.tinted(withColor: skin.toolbarTintColor)
                            item.setTitleTextAttributes([NSForegroundColorAttributeName: skin.toolbarItemColor], for: .normal)
                            item.setTitleTextAttributes([NSForegroundColorAttributeName: skin.toolbarTintColor], for: .selected)
                        }
                    }
                }
            }
        }

        parent?.propagateSkin(why: "parent")
    }

    public func _preferredStatusBarStyle(for skin: Skin?) -> UIStatusBarStyle {
        let style = skin?.statusBarStyle ?? .default
        logTrace("style: \(style.rawValue)", obj: self, group: .statusBar)
        return style
    }
}
