//
//  NavigationController.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class NavigationController: UINavigationController, UINavigationControllerDelegate, Skinnable {
    public var onWillShow: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    public var onDidShow: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _setup()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        _setup()
    }

    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        _setup()
    }

    private func _setup() {
        logInfo("init \(self)", group: .viewControllerLifecycle)
        setupNavbar()
        setup()
    }

    private var effectView: UIVisualEffectView!

    private func setupNavbar() {
        let effect = UIBlurEffect(style: .light)
        effectView = ~UIVisualEffectView(effect: effect)
        // Add the effect view as a the first subview of the _UIBarBackground view
        navigationBar.subviews[0].insertSubview(effectView, at: 0)
        navigationBar.backgroundColor = .clear
        activateConstraints(
            effectView.leftAnchor == navigationBar.leftAnchor,
            effectView.rightAnchor == navigationBar.rightAnchor,
            effectView.bottomAnchor == navigationBar.bottomAnchor,
            effectView.topAnchor == navigationBar.topAnchor - 20
        )
    }

    deinit {
        logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.debugIdentifier = "\(typeName(of: self)).view"
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        propagateSkin(why: "viewWillAppear")
    }

    open override var childViewControllerForStatusBarStyle: UIViewController? {
        let child = topViewController
        logTrace("statusBarStyle redirect to \(child†)", obj: self, group: .statusBar)
        return child
    }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return _preferredStatusBarStyle(for: skin)
    }

    open func setup() { }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        onWillShow?(navigationController, animated)
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        onDidShow?(navigationController, animated)
    }
}
