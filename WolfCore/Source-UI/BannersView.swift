//
//  BannersView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/25/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

class BannersView: View {
    private struct FlyerView {
        let flyer: Flyer
        let view: UIView

        init(flyer: Flyer, view: UIView) {
            self.flyer = flyer
            self.view = view
        }
    }

    private var flyerViews = [FlyerView]()
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

    private func index(of flyer: Flyer) -> Int? {
        return flyerViews.index { return $0.flyer.uuid == flyer.uuid }
    }

    func addView(_ view: UIView, for flyer: Flyer, animated: Bool, animations: @escaping Block) {
        assert(view.superview == nil)

        let flyerView = FlyerView(flyer: flyer, view: view)
        flyerViews.append(flyerView)
        flyerViews.sort { $0.flyer.priority == $1.flyer.priority ? $0.flyer.date < $1.flyer.date : $0.flyer.priority < $1.flyer.priority }

        let viewIndex = index(of: flyer)!

        stackView.insertArrangedSubview(view, at: viewIndex)
        stackView.layoutIfNeeded()
        let bottomOffset = stackView.frame.height - view.frame.maxY
        view.removeFromSuperview()

        stackView.insertSubview(view, at: 0)
        activateConstraints(
            view.leadingAnchor == stackView.leadingAnchor,
            view.trailingAnchor == stackView.trailingAnchor,
            view.bottomAnchor == stackView.bottomAnchor - bottomOffset
        )
        stackView.layoutIfNeeded()
        view.removeFromSuperview()

        stackView.insertArrangedSubview(view, at: viewIndex)
        view.alpha = 0
        dispatchAnimated(animated, options: [.allowUserInteraction, .beginFromCurrentState]) {
            view.alpha = 1
            animations()
        }.run()
    }

    func removeView(for flyer: Flyer, animated: Bool, animations: @escaping Block) {
        guard let viewIndex = index(of: flyer) else { return }
        let flyerView = flyerViews[viewIndex]
        let view = flyerView.view
        view.removeFromSuperview()
        stackView.insertSubview(view, at: 0)
        activateConstraints(
            view.leadingAnchor == stackView.leadingAnchor,
            view.trailingAnchor == stackView.trailingAnchor,
            view.bottomAnchor == stackView.bottomAnchor - (stackView.frame.height - view.frame.maxY)
        )
        flyerViews.remove(at: viewIndex)
        dispatchAnimated(animated, options: [.allowUserInteraction, .beginFromCurrentState]) {
            view.alpha = 0
            animations()
        }.then { _ in
            view.removeFromSuperview()
        }.run()
    }

    func heightForBanners(count: Int) -> CGFloat {
        var height: CGFloat = 0
        for (viewIndex, banner) in flyerViews.reversed().enumerated() {
            guard viewIndex < count else { break }
            height += banner.view.frame.height
        }
        return height
    }
}
