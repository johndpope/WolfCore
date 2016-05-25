//
//  Label.swift
//  WolfCore
//
//  Created by Robert McNally on 7/22/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class Label: UILabel {
    public var transparentToTouches: Bool = false
    public var followsTintColor: Bool = false {
        didSet {
            syncToTintColor()
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        syncToTintColor()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    // Override in subclasses
    public func setup() { }

    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if transparentToTouches {
            return tranparentPointInside(point, withEvent: event)
        } else {
            return super.pointInside(point, withEvent: event)
        }
    }
}

extension Label {
    func syncToTintColor() {
        if followsTintColor {
            textColor = tintColor ?? .Black
        }
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        syncToTintColor()
    }
}
