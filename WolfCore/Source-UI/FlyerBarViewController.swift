//
//  FlyerBarViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class FlyerBarViewController: ViewController {
    public enum PresentationStyle {
        case overlayFlyerViews
        case compressMainView
    }

    private let flyerBarHeight: CGFloat
    private let presentationStyle: PresentationStyle
    private let maxFlyersVisible: Int

    public init(flyerBarHeight: CGFloat = 40, presentationStyle: PresentationStyle = .compressMainView, maxFlyersVisible: Int = 1) {
        self.flyerBarHeight = flyerBarHeight
        self.presentationStyle = presentationStyle
        self.maxFlyersVisible = maxFlyersVisible
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }

    private func hasFlyer(_ flyer: Flyer) -> Bool {
        return indexOfFlyer(flyer) != nil
    }

    private func indexOfFlyer(_ flyer: Flyer) -> Int? {
        return flyerRecords.index {
            return $0.flyer === flyer
        }
    }

    public func addFlyerView<T: UIView>(_ flyerView: T) where T: Flyer {
        guard !hasFlyer(flyerView) else { return }

        flyerViewsContainer.addSubview(flyerView)
        let topConstraint = flyerView.topAnchor == flyerViewsContainer.topAnchor
        let record = FlyerRecord(flyer: flyerView, topConstraint: topConstraint)
        flyerRecords.append(record)

        flyerRecords.sort { $0.flyer.priority < $1.flyer.priority }
        let index = indexOfFlyer(flyerView)!

        flyerViewsContainer.insertSubview(flyerView, at: index)
        activateConstraints(
            flyerView.leadingAnchor == flyerViewsContainer.leadingAnchor,
            flyerView.trailingAnchor == flyerViewsContainer.trailingAnchor,
            topConstraint,
            flyerView.heightAnchor == flyerBarHeight
        )
    }

    public func removeFlyerView<T: UIView>(_ flyerView: T) where T: Flyer {
        guard let index = indexOfFlyer(flyerView) else { return }

        flyerView.removeFromSuperview()
        flyerRecords.remove(at: index)
    }

    private struct FlyerRecord {
        let flyer: Flyer
        let topConstraint: NSLayoutConstraint
    }

    private private(set) var flyerRecords = [FlyerRecord]()

    private lazy var flyerViewsContainer: View = {
        let view = View()
        return view
    }()

    private lazy var mainViewContainer: View = {
        let view = View()
        return view
    }()

    private var flyerViewsContainerTopConstraint: NSLayoutConstraint!

    public override func setup() {
        super.setup()

        view => [
            mainViewContainer,
            flyerViewsContainer
        ]

        flyerViewsContainerTopConstraint = flyerViewsContainer.topAnchor == view.topAnchor

        activateConstraints(
            flyerViewsContainer.leadingAnchor == view.leadingAnchor,
            flyerViewsContainer.trailingAnchor == view.trailingAnchor,
            flyerViewsContainerTopConstraint,
            flyerViewsContainer.heightAnchor == flyerBarHeight,

            mainViewContainer.leadingAnchor == view.leadingAnchor,
            mainViewContainer.trailingAnchor == view.trailingAnchor,
            mainViewContainer.bottomAnchor == view.bottomAnchor
        )

        switch presentationStyle {
        case .compressMainView:
            activateConstraints(
                mainViewContainer.topAnchor == flyerViewsContainer.bottomAnchor
            )
        case .overlayFlyerViews:
            activateConstraints(
                mainViewContainer.topAnchor == view.topAnchor
            )
        }
    }

    public var mainViewController: UIViewController? {
        willSet {
            guard let mainViewController = mainViewController else { return }
            
            mainViewController.willMove(toParentViewController: nil)
            mainViewController.removeFromParentViewController()
            mainViewController.view.removeFromSuperview()
        }
        didSet {
            guard let mainViewController = mainViewController else { return }

            addChildViewController(mainViewController)
            mainViewContainer => [
                mainViewController.view
            ]

            mainViewController.view.constrainFrame()
        }
    }
}
