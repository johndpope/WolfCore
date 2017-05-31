//
//  BannerViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public struct BulletinView {
    public let bulletin: Bulletin
    public let view: UIView

    init(bulletin: Bulletin, view: UIView) {
        self.bulletin = bulletin
        self.view = view
    }
}

open class BannerViewController: ViewController {
    public typealias PublishableType = Bulletin
    public typealias PublisherType = Publisher<PublishableType>

    public enum PresentationStyle {
        case overlayBulletinViews
        case compressMainView
    }

    private var subscriber = Subscriber<PublishableType>()

    private var bannersContainerHeightConstraint: NSLayoutConstraint!
    private var presentationStyle: PresentationStyle! = .compressMainView
    private var maxBannersVisible: Int! = 5

    open override func setup() {
        super.setup()

        subscriber.onAddedItem = { [unowned self] item in
            self.addView(for: item)
        }

        subscriber.onRemovedItem = { [unowned self] item in
            self.removeView(for: item)
        }
    }

    public init(presentationStyle: PresentationStyle = .compressMainView, maxBannersVisible: Int = 1) {
        super.init(nibName: nil, bundle: nil)
        self.presentationStyle = presentationStyle
        self.maxBannersVisible = maxBannersVisible
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func subscribe(to publisher: PublisherType) {
        subscriber.subscribe(to: publisher)
    }

    public func unsubscribe(from publisher: PublisherType) {
        subscriber.unsubscribe(from: publisher)
    }

    private func addView(for bulletin: Bulletin) {
        addBulletinView(bulletin.newBulletinView())
    }

    private func addBulletinView(_ bulletinView: BulletinView) {
        bannersView.addBulletinView(bulletinView, animated: true) {
            self.syncToVisibleBanners()
        }
    }

    private func removeView(for bulletin: Bulletin) {
        bannersView.removeView(for: bulletin, animated: true) {
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
        case .overlayBulletinViews:
            activateConstraints(
                contentViewContainer.topAnchor == view.topAnchor
            )
        }
    }

    override open func updateAppearance(skin: Skin?) {
        super.updateAppearance(skin: skin)
        guard let skin = skin else { return }
        view.normalBackgroundColor = skin.bannerBarBackgroundColor
        setNeedsStatusBarAppearanceUpdate()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return skin.bannerBarStyle
    }
}
