//
//  BarButtonAction.swift
//  WolfCore
//
//  Created by Robert McNally on 2/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

private let barButtonActionSelector = #selector(BarButtonItemAction.itemAction)

public class BarButtonItemAction: NSObject {
    public var action: Block?
    public let item: UIBarButtonItem

    public init(item: UIBarButtonItem, action: Block? = nil) {
        self.item = item
        self.action = action
        super.init()
        item.target = self
        item.action = barButtonActionSelector
    }

    public func itemAction() {
        action?()
    }
}
