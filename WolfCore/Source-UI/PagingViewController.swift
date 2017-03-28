//
//  PagingViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class PagingViewController: ViewController {
    @IBOutlet public weak var bottomView: UIView!

    public private(set) var pagingView = PagingView()
    private var bottomViewToPageControlConstraint: NSLayoutConstraint!

    open override func setup() {
        super.setup()
        automaticallyAdjustsScrollViewInsets = false
        pagingView.onDidLayout = { [unowned self] (fromIndex, toIndex, frac) in
            self.didLayoutPagingView(fromIndex: fromIndex, toIndex: toIndex, frac: frac)
        }
    }

    open func didLayoutPagingView(fromIndex: Int, toIndex: Int, frac: Frac) {
        let fromController = pagedViewControllers[fromIndex]
        let fromSkin = fromController.skin!
        let skin: Skin
        if frac == 0.0 {
            skin = fromSkin
        } else {
            let toController = pagedViewControllers[toIndex]
            let toSkin = toController.skin!
            skin = fromSkin.interpolated(to: toSkin, at: frac)
        }
        self.skin = skin
    }

    public var pagedViewControllers: [UIViewController]! {
        didSet {
            pagingView.arrangedViews = []
            for viewController in childViewControllers {
                viewController.removeFromParentViewController()
            }
            var pageViews = [UIView]()
            for viewController in pagedViewControllers {
                addChildViewController(viewController)
                pageViews.append(viewController.view)
            }
            pagingView.arrangedViews = pageViews
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.insertSubview(pagingView, at: 0)
        pagingView.constrainFrame()

        if let bottomView = bottomView {
            bottomViewToPageControlConstraint = pagingView.pageControl.bottomAnchor == bottomView.topAnchor - 20
            bottomViewToPageControlConstraint.isActive = true
        }
    }

    open override var childViewControllerForStatusBarStyle: UIViewController? {
        guard pagingView.pageControl.numberOfPages == pagedViewControllers?.count else { return nil }
        let child = pagedViewControllers?[pagingView.currentPage]
        logTrace("statusBarStyle redirect to \(child†)", obj: self, group: .statusBar)
        return child
    }
}
