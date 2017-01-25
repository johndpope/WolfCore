//
//  TableViewCell.swift
//  WolfCore
//
//  Created by Robert McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

open class TableViewCell: UITableViewCell, Skinnable {
    public var mySkin: Skin?
    public var skinChangedAction: SkinChangedAction!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setup()
    }

    private func _setup() {
        setup()
        setupSkinnable()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    open func setup() { }
}
