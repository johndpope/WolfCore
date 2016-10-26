//
//  NetworkActivity.swift
//  WolfCore
//
//  Created by Robert McNally on 6/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public let networkActivity = NetworkActivity()

public class NetworkActivity {
    private let hysteresis: Hysteresis

    init() {
        hysteresis = Hysteresis(
            onEffectStart: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            },
            onEffectEnd: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            },
            effectStartLag: 0.2,
            effectEndLag: 0.2
        )
    }

    public func newActivity() -> Locker.Ref {
        return hysteresis.newCause()
    }
}
