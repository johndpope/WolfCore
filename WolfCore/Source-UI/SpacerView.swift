//
//  SpacerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class SpacerView: View {
    public var width: CGFloat = UIViewNoIntrinsicMetric {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public var height: CGFloat = UIViewNoIntrinsicMetric{
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public init(height: CGFloat = 10) {
        self.height = height
        super.init(frame: .zero)
        setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.height = 10
        super.init(coder: aDecoder)
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }
}
