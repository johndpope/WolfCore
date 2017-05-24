//
//  BannerViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public struct Banner {
    let view: UIView
    let uuid: UUID
    let addedDate: Date
    let priority: Int
    let duration: TimeInterval?

    init(view: UIView, uuid: UUID, addedDate: Date, priority: Int, duration: TimeInterval?) {
        self.view = view
        self.uuid = uuid
        self.addedDate = addedDate
        self.priority = priority
        self.duration = duration
    }
}

class BannersContainerView: View {
    private var banners = [Banner]()
    private var heightConstraint: NSLayoutConstraint!

    private var stackView: VerticalStackView = {
        let view = VerticalStackView()
        return view
    }()

    override func setup() {
        super.setup()

        clipsToBounds = true
        
        self => [
            stackView
        ]

        activateConstraints(
            stackView.leadingAnchor == leadingAnchor,
            stackView.trailingAnchor == trailingAnchor,
            stackView.bottomAnchor == bottomAnchor
        )
    }

    private func indexOfBanner(_ banner: Banner) -> Int? {
        return banners.index { return $0.uuid == banner.uuid }
    }

    func addBanner(view bannerView: UIView, priority: Int, duration: TimeInterval?, animated: Bool, animations: @escaping Block) -> Banner {
        assert(bannerView.superview == nil)

        let uuid = UUID()
        let addedDate = Date()
        let banner = Banner(view: bannerView, uuid: uuid, addedDate: addedDate, priority: priority, duration: duration)
        banners.append(banner)
        banners.sort { $0.priority == $1.priority ? $0.addedDate < $1.addedDate : $0.priority < $1.priority }

        let index = indexOfBanner(banner)!

        bannerView.alpha = 0
        stackView.insertArrangedSubview(bannerView, at: index)
        bannerView.frame = stackView.bounds
        bannerView.layoutIfNeeded()
        dispatchAnimated(animated) {
            self.stackView.layoutIfNeeded()
            bannerView.alpha = 1
            animations()
        }.run()

        return banner
    }

    func removeBanner(_ banner: Banner, animations: @escaping Block) {
        guard let index = indexOfBanner(banner) else { return }
        stackView.removeArrangedSubview(banner.view)
        dispatchAnimated {
            banner.view.alpha = 0
            self.banners.remove(at: index)
            animations()
        }.then { _ in
            banner.view.removeFromSuperview()
        }.run()
    }

    func heightForBanners(count: Int) -> CGFloat {
        var height: CGFloat = 0
        for (index, banner) in banners.reversed().enumerated() {
            guard index < count else { break }
            height += banner.view.frame.height
        }
        return height
    }
}

open class BannerViewController: ViewController {
    public enum PresentationStyle {
        case overlayFlyerViews
        case compressMainView
    }

    private var bannersContainerHeightConstraint: NSLayoutConstraint!
    private var presentationStyle: PresentationStyle! = .compressMainView
    private var maxBannersVisible: Int! = 1

    public init(presentationStyle: PresentationStyle = .compressMainView, maxBannersVisible: Int = 1) {
        super.init(nibName: nil, bundle: nil)
        self.presentationStyle = presentationStyle
        self.maxBannersVisible = maxBannersVisible
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @discardableResult public func addBanner(view bannerView: UIView, priority: Int = 500, duration: TimeInterval? = nil) -> Banner {
        //self.view.setNeedsLayout()
        let banner = bannersContainer.addBanner(view: bannerView, priority: priority, duration: duration, animated: true) {
            self.syncToVisibleBanners()
        }
        return banner
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
        let heightForBanners = bannersContainer.heightForBanners(count: maxBannersVisible)
        bannersContainerHeightConstraint.constant = heightForBanners
        if heightForBanners > 0 {
            replaceConstraint(&bannersContainerTopConstraint, with: bannersContainer.topAnchor == topLayoutGuide.bottomAnchor)
            hasVisibleBanners = true
        } else {
            replaceConstraint(&bannersContainerTopConstraint, with: bannersContainer.topAnchor == view.topAnchor)
            hasVisibleBanners = false
        }
        view.layoutIfNeeded()
        setNeedsStatusBarAppearanceUpdate()
    }

    public func removeBanner(_ banner: Banner) {
        bannersContainer.removeBanner(banner) {
            self.syncToVisibleBanners()
        }
    }

    private lazy var bannersContainer: BannersContainerView = {
        let view = BannersContainerView()
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
            bannersContainer
        ]

        bannersContainerTopConstraint = bannersContainer.topAnchor == view.topAnchor
        bannersContainerHeightConstraint = bannersContainer.heightAnchor == 0

        activateConstraints(
            bannersContainer.leadingAnchor == view.leadingAnchor,
            bannersContainer.trailingAnchor == view.trailingAnchor,
            bannersContainerTopConstraint!,
            bannersContainerHeightConstraint,

            contentViewContainer.leadingAnchor == view.leadingAnchor,
            contentViewContainer.trailingAnchor == view.trailingAnchor,
            contentViewContainer.bottomAnchor == view.bottomAnchor
        )

        switch presentationStyle! {
        case .compressMainView:
            activateConstraints(
                contentViewContainer.topAnchor == bannersContainer.bottomAnchor
            )
        case .overlayFlyerViews:
            activateConstraints(
                contentViewContainer.topAnchor == view.topAnchor
            )
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
}
