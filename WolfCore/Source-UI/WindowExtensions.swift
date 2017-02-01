//
//  WindowExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

extension UIWindow {
    public func replaceRootViewController(with newController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)

        func onCompletion() {
            snapshotImageView.removeFromSuperview()
            completion?()
        }

        func animateTransition() {
            rootViewController = newController
            bringSubview(toFront: snapshotImageView)
            if animated {
                dispatchAnimated(animations: {
                    snapshotImageView.alpha = 0
                }, completion: { _ in
                    onCompletion()
                })
            } else {
                onCompletion()
            }
        }

        if let presentedViewController = rootViewController?.presentedViewController {
            presentedViewController.dismiss(animated: false) {
                animateTransition()
            }
        } else {
            animateTransition()
        }
    }
}
