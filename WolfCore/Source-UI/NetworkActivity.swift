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
            effectStart: {
                UIApplication.shared().isNetworkActivityIndicatorVisible = true
            },
            effectEnd: {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            },
            effectStartLag: 0.2,
            effectEndLag: 0.2
        )
    }

    public func newActivity() -> ReferenceCounter.Ref {
        return hysteresis.newCause()
    }
}
