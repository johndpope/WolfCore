//
//  DividerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/8/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class DividerView: View {
    public typealias `Self` = DividerView

    public enum Position {
        case top
        case bottom
    }

    private let position: Position

    private static let defaultColor = UIColor(white: 0, alpha: 0.1)

    public init(position: Position = .bottom, color: UIColor = Self.defaultColor) {
        self.position = position
        super.init(frame: .zero)
        normalBackgroundColor = color
    }

    required public init?(coder aDecoder: NSCoder) {
        self.position = .bottom
        super.init(coder: aDecoder)
        normalBackgroundColor = .white
    }

    public override func setup() {
        super.setup()
        activateConstraint(heightAnchor == 0.5)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            activateConstraints(
                widthAnchor == superview.widthAnchor,
                centerXAnchor == superview.centerXAnchor
            )
            switch position {
            case .top:
                activateConstraint(topAnchor == superview.topAnchor)
            case .bottom:
                activateConstraint(bottomAnchor == superview.bottomAnchor)
            }
        }
    }
}
