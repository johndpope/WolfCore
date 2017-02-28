//
//  PageControl.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/25/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class PageControl: UIPageControl, Skinnable {
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
        __setup()
        setup()
    }

    open func setup() { }

    open func updateAppearance(skin: Skin?) {
        _updateAppearance(skin: skin)
        guard let skin = skin else { return }
        pageIndicatorTintColor = skin.pageIndicatorTintColor
        currentPageIndicatorTintColor = skin.currentPageIndicatorTintColor
    }
}
