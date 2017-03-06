//
//  NetworkActivity.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/17/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if !os(macOS)
import UIKit
#endif

public let networkActivity = NetworkActivity()

public class NetworkActivity {
    private let hysteresis: Hysteresis

    init() {
        hysteresis = Hysteresis(
            onEffectStart: {
                #if !os(macOS)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                #endif
            },
            onEffectEnd: {
                #if !os(macOS)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                #endif
            },
            effectStartLag: 0.2,
            effectEndLag: 0.2
        )
    }

    public func newActivity() -> Locker.Ref {
        return hysteresis.newCause()
    }
}
