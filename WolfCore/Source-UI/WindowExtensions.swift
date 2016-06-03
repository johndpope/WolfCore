//
//  WindowExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

extension UIWindow {
    public func replaceRootViewController(withController newController: UIViewController, animated: Bool = true) {
        let oldRootView = rootViewController?.view
        let newRootView = newController.view
        if animated {
            dispatchAnimated(
                animations: {
                    oldRootView?.alpha = 0.0
                },
                completion: { _ in
                    newRootView.alpha = 0.0
                    self.rootViewController = newController
                    NSRunLoop.currentRunLoop().runOnce()
                    oldRootView?.alpha = 1.0
                    dispatchAnimated {
                        newRootView.alpha = 1.0
                    }
                }
            )
        } else {
            rootViewController = newController
        }
    }
}
