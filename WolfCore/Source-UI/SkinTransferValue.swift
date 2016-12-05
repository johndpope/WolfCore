//
//  SkinTransferValue.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class SkinTransferValue<T: Any>: TransferValue<T>, Skinnable {
    public var skinChangedAction: SkinChangedAction!
    public override init(withDefault defaultValue: T, sink: Sink?) {
        super.init(withDefault: defaultValue, sink: sink)
        setupSkinnable()
    }
    public func updateAppearance() {
        transfer()
    }
}
