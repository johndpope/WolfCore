//
//  SkinColor.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class SkinColor: SkinTransferValue<UIColor> {
    public override init(withDefault defaultValue: UIColor = .black, sink: Sink? = nil) {
        super.init(withDefault: defaultValue, sink: sink)
    }
}
