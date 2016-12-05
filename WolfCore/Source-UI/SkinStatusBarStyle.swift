//
//  SkinStatusBarStyle.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class SkinStatusBarStyle: SkinTransferValue<UIStatusBarStyle> {
    public override init(withDefault defaultValue: UIStatusBarStyle = .default, sink: Sink? = nil) {
        super.init(withDefault: defaultValue, sink: sink)
    }
}
