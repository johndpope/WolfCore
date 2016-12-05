//
//  Skinnable.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public protocol Skinnable: class {
    func updateAppearance()
    var skinChangedAction: SkinChangedAction! { get set }
}

extension Skinnable {
    public func setupSkinnable() {
        skinChangedAction = SkinChangedAction(for: self)
    }
}
