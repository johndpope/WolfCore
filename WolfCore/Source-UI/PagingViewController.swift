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
        pagingView.constrainToSuperview()

        if let bottomView = bottomView {
            bottomViewToPageControlConstraint = pagingView.pageControl.bottomAnchor == bottomView.topAnchor - 20
            bottomViewToPageControlConstraint.isActive = true
        }
    }

    open override var childViewControllerForStatusBarStyle: UIViewController? {
        let child = pagedViewControllers?[pagingView.currentPage]
        print("statusBarStyle from: \(self) ---> \(child)")
        return child
    }
}
