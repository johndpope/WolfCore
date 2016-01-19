//
//  ScrollView.swift
//  WolfCore
//
//  Created by Robert McNally on 12/7/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import UIKit

public class ScrollView : UIScrollView {
    public var transparentToTouches: Bool = false
    
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
