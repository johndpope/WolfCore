//
//  ViewControllerDebugging.swift
//  WolfCore
//
//  Created by Robert McNally on 5/18/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

extension UIViewController {
    public func printControllerHierarchy() {
        let aliaser = ObjectAliaser()
        var stack = [(controller: UIViewController, level: Int, indent: String)]()

        stack.append((self, 0, ""))

        repeat {
            let (controller, level, indent) = stack.removeLast()

            let joiner = Joiner()

            joiner.append(prefix(for: controller))

            controller.childViewControllers.reversed().forEach { childController in
                stack.append((childController, level + 1, indent + "  |"))
            }

            joiner.append( indent, "\(level)".padded(toCount: 2) )
            joiner.append(aliaser.name(forObject: controller))

            if !controller.automaticallyAdjustsScrollViewInsets {
                joiner.append("automaticallyAdjustsScrollViewInsets:\(controller.automaticallyAdjustsScrollViewInsets)")
            }

            if let presentedViewController = controller.presentedViewController {
                if presentedViewController != controller.parent?.presentedViewController {
                    stack.insert((presentedViewController, 0, ""), at: 0)
                    joiner.append("presents:\(aliaser.name(forObject: presentedViewController))")
                }
            }

            if let presentingViewController = controller.presentingViewController {
                if presentingViewController != controller.parent?.presentingViewController {
                    joiner.append("presentedBy:\(aliaser.name(forObject: presentingViewController))")
                }
            }

            print(joiner)
        } while !stack.isEmpty
    }

    private func prefix(for controller: UIViewController) -> String {
        var prefix: String!

        if prefix == nil {
            for window in UIApplication.shared().windows {
                if let rootViewController = window.rootViewController {
                    if controller == rootViewController {
                        prefix = "🌳"
                    }
                }
            }
        }

        if prefix == nil {
            if let presentingViewController = controller.presentingViewController {
                if presentingViewController != controller.parent?.presentingViewController {
                    prefix = "🎁"
                }
            }
        }

        if prefix == nil {
            prefix = "⬜️"
        }

        return prefix
    }
}

public func printRootControllerHierarchy() {
    UIApplication.shared().windows[0].rootViewController?.printControllerHierarchy()
}
