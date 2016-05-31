//
//  CollectionViewCell.swift
//  WolfCore
//
//  Created by Robert McNally on 5/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class CollectionViewCell: UICollectionViewCell {
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
}
