//
//  CollectionViewCell.swift
//  WolfCore
//
//  Created by Robert McNally on 5/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class CollectionViewCell: UICollectionViewCell {
    private var skinChangedAction: SkinChangedAction!

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
        skinChangedAction = SkinChangedAction(for: self) { [unowned self] in
            self.updateAppearance()
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    /// Override in subclasses
    open func setup() { }

    /// Override in subclasses
    open func updateAppearance() { }
}
