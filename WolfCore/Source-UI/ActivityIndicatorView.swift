//
//  ActivityIndicatorView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class ActivityIndicatorView: View {
    private let style: UIActivityIndicatorViewStyle
    private var hysteresis: Hysteresis!

    public init(activityIndicatorStyle style: UIActivityIndicatorViewStyle = .white) {
        self.style = style

        super.init(frame: .zero)

        hysteresis = Hysteresis(
            onEffectStart: {
                dispatchOnMain {
                    self.activityIndicatorView.show(animated: true)
                }
        },
            onEffectEnd: {
                dispatchOnMain {
                    self.activityIndicatorView.hide(animated: true)
                }
        },
            effectStartLag: 0.25,
            effectEndLag: 0.2
        )
    }

    private func revealIndicator(animated: Bool) {
        activityIndicatorView.show(animated: animated)
    }

    private func concealIndicator(animated: Bool) {
        activityIndicatorView.hide(animated: animated)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func newActivity() -> Locker.Ref {
        return hysteresis.newCause()
    }

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = ~UIActivityIndicatorView(activityIndicatorStyle: self.style)
        view.hidesWhenStopped = false
        view.startAnimating()
        return view
    }()

    override public func setup() {
        super.setup()

        setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)

        self => [
            activityIndicatorView
        ]

        activityIndicatorView.constrainCenterToCenter()
        activateConstraints(
            widthAnchor == activityIndicatorView.widthAnchor =&= UILayoutPriorityDefaultLow,
            heightAnchor == activityIndicatorView.heightAnchor =&= UILayoutPriorityDefaultLow
        )

        concealIndicator(animated: false)
    }
}
