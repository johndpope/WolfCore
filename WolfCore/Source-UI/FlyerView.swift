//
//  FlyerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/20/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class FlyerView: View, Flyer {
    public let priority: Int
    public let duration: TimeInterval?

    private lazy var messageLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    public init(priority: Int, duration: TimeInterval?, backgroundColor: UIColor = .white, foregroundColor: UIColor = .black) {
        self.priority = priority
        self.duration = duration
        super.init(frame: .zero)
        self.normalBackgroundColor = backgroundColor
        self.messageLabel.textColor = foregroundColor
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()
        self => [
            messageLabel
        ]

        messageLabel.constrainCenterToCenter()
        activateConstraints(
            messageLabel.widthAnchor == widthAnchor - 40,
            messageLabel.heightAnchor <= heightAnchor - 20
        )
    }
}
