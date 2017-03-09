//
//  SpacerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class SpacerView: View {
    private var heightConstraint: NSLayoutConstraint!

    public var height: CGFloat {
        get {
            return heightConstraint.constant
        }

        set {
            heightConstraint.constant = newValue
        }
    }

    public init(height: CGFloat = 10) {
        super.init(frame: .zero)
        heightConstraint = activateConstraint(heightAnchor == height)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
