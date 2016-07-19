//
//  StackView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class StackView: UIStackView {
    public var transparentToTouches = false

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(arrangedSubviews views: [UIView]) {
        self.init(arrangedSubviews: views)
        _setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        _setup()
    }

    private func _setup() {
        ~self
        setup()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    /// Override in subclasses
    public func setup() { }

    /// Override in subclasses
    public func updateAppearance() { }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}

extension UILayoutConstraintAxis: CustomStringConvertible {
    public var description: String {
        switch self {
        case .horizontal:
            return ".horizontal"
        case .vertical:
            return ".vertical"
        }
    }
}

extension UIStackViewDistribution: CustomStringConvertible {
    public var description: String {
        switch self {
        case .equalCentering:
            return ".equalCentering"
        case .equalSpacing:
            return ".equalSpacing"
        case .fill:
            return ".fill"
        case .fillEqually:
            return ".fillEqually"
        case .fillProportionally:
            return ".fillProportionally"
        }
    }
}

extension UIStackViewAlignment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .center:
            return ".center"
        case .fill:
            return ".fill"
        case .firstBaseline:
            return ".firstBaseline"
        case .lastBaseline:
            return ".lastBaseline"
        case .leading:
            return ".leading"
        case .trailing:
            return ".trailing"
        }
    }
}
