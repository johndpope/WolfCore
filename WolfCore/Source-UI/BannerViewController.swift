//
//  BannerViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class BannerViewController: ViewController {
    public enum PresentationStyle {
        case overlayFlyerViews
        case compressMainView
    }

    private var bannersContainerHeightConstraint: NSLayoutConstraint!
    private var presentationStyle: PresentationStyle! = .compressMainView
    private var maxBannersVisible: Int! = 5

    public init(presentationStyle: PresentationStyle = .compressMainView, maxBannersVisible: Int = 1) {
        super.init(nibName: nil, bundle: nil)
        self.presentationStyle = presentationStyle
        self.maxBannersVisible = maxBannersVisible
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func addView(_ bannerView: UIView, for flyer: Flyer) {
        bannersView.addView(bannerView, for: flyer, animated: true) {
            self.syncToVisibleBanners()
        }
    }

    public func removeView(for flyer: Flyer) {
        bannersView.removeView(for: flyer, animated: true) {
            self.syncToVisibleBanners()
        }
    }

    public var contentViewController: UIViewController? {
        willSet {
            guard let contentViewController = contentViewController else { return }

            contentViewController.willMove(toParentViewController: nil)
            contentViewController.removeFromParentViewController()
            contentViewController.view.removeFromSuperview()
        }
        didSet {
            guard let contentViewController = contentViewController else { return }

            let newView = contentViewController.view!
            newView.translatesAutoresizingMaskIntoConstraints = false

            addChildViewController(contentViewController)
            contentViewContainer => [
                newView
            ]

            newView.constrainFrame(to: contentViewContainer)

            setNeedsStatusBarAppearanceUpdate()
        }
    }

    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return contentViewController
    }

    open override var childViewControllerForStatusBarStyle: UIViewController? {
        if hasVisibleBanners {
            return nil
        } else {
            return contentViewController
        }
    }

    private var bannersContainerTopConstraint: NSLayoutConstraint?

    private var hasVisibleBanners = false

    private func syncToVisibleBanners() {
        let heightForBanners = bannersView.heightForBanners(count: maxBannersVisible)
        bannersContainerHeightConstraint.constant = heightForBanners
        if heightForBanners > 0 {
            replaceConstraint(&bannersContainerTopConstraint, with: bannersView.topAnchor == topLayoutGuide.bottomAnchor)
            hasVisibleBanners = true
        } else {
            replaceConstraint(&bannersContainerTopConstraint, with: bannersView.topAnchor == view.topAnchor)
            hasVisibleBanners = false
        }
        view.layoutIfNeeded()
        setNeedsStatusBarAppearanceUpdate()
    }

    private lazy var bannersView: BannersView = {
        let view = BannersView()
        return view
    }()

    private lazy var contentViewContainer: View = {
        let view = View()
        return view
    }()

    open override func build() {
        super.build()

        view => [
            contentViewContainer,
            bannersView
        ]

        bannersContainerTopConstraint = bannersView.topAnchor == view.topAnchor
        bannersContainerHeightConstraint = bannersView.heightAnchor == 0

        activateConstraints(
            bannersView.leadingAnchor == view.leadingAnchor,
            bannersView.trailingAnchor == view.trailingAnchor,
            bannersContainerTopConstraint!,
            bannersContainerHeightConstraint,

            contentViewContainer.leadingAnchor == view.leadingAnchor,
            contentViewContainer.trailingAnchor == view.trailingAnchor,
            contentViewContainer.bottomAnchor == view.bottomAnchor
        )

        switch presentationStyle! {
        case .compressMainView:
            activateConstraints(
                contentViewContainer.topAnchor == bannersView.bottomAnchor
            )
        case .overlayFlyerViews:
            activateConstraints(
                contentViewContainer.topAnchor == view.topAnchor
            )
        }
    }
}
