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
        let newRootView: UIView = newController.view
        if animated {
            newRootView.alpha = 0.0
            self.rootViewController = newController
            //RunLoop.current.runOnce()
            dispatchAnimated(
                animations: {
                    newRootView.alpha = 1.0
            },
                completion: { _ in
                    self.subviews[0].removeFromSuperview()
            }
            )
        } else {
            rootViewController = nil
            subviews[0].removeFromSuperview()
            rootViewController = newController
        }
    }
}
