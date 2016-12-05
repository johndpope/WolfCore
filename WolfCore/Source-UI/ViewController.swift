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

    open func updateAppearance() { }
}
