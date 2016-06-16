//
//  NavigationController.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController {
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
        logInfo("init \(self)", group: viewControllerLifecycleLogGroup)
        setup()
    }

    public func setup() {
    }

    deinit {
        logInfo("deinit \(self)", group: viewControllerLifecycleLogGroup)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: viewControllerLifecycleLogGroup)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateAppearance()
    }

    /// Override in subclasses
    public func updateAppearance() { }
}
