//
//  TabBarController.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class TabBarController: UITabBarController, Skinnable {
    public var mySkin: Skin?
    public var skinChangedAction: SkinChangedAction!

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
        setupSkinnable()
    }

    deinit {
        logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateAppearance()
    }

    open func setup() { }
}
