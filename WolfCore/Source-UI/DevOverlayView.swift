//
//  DevOverlayView.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public var devOverlay = DevOverlayView()

public class DevOverlayView: View {

    public override func setup() {
        super.setup()

        let window = UIApplication.shared().windows[0]
        window.addSubview(self)
        transparentToTouches = true
        bounds = window.frame
        constrainToSuperview(identifier: "DevOverlay")
        makeTransparent(debugColor: .red, debug: false)
        dispatchRepeatedOnMain(atInterval: 0.2) { canceler in
            window.bringSubview(toFront: self)
        }
    }
}
