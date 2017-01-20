//
//  PagingViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class PagingViewController: ViewController {
    private var mainView = UIView()
    private var pagingView = PagingView()

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
    
    open override func loadView() {
        mainView.addSubview(pagingView)
        pagingView.constrainToSuperview()
        self.view = mainView
    }
}
