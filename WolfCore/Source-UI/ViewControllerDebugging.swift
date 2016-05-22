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
        var seenControllers = Set<UIViewController>()
        
        stack.append((self, 0, ""))
        
        repeat {
            let (controller, level, indent) = stack.removeLast()
            
            let joiner = Joiner("", "", " ")
            
            var isRootPrefix = "⬜️"
            for window in UIApplication.sharedApplication().windows {
                if let rootViewController = window.rootViewController {
                    if controller == rootViewController {
                        isRootPrefix = "🌳"
                    }
                }
            }
            joiner.append(isRootPrefix)
            
            var isPresentedPrefix = "⬜️"
            if !seenControllers.contains(controller) {
                if let presentedViewController = controller.presentedViewController {
                    if !controller.childViewControllers.contains(presentedViewController) {
                        stack.append((presentedViewController, level + 1, indent + "  |"))
                        isPresentedPrefix = "🎁"
                    }
                }
                
                controller.childViewControllers.reverse().forEach { childController in
                    stack.append((childController, level + 1, indent + "  |"))
                }
            }
            joiner.append(isPresentedPrefix)
            
            joiner.append( indent, "\(level)".padded(toCount: 2) )
            joiner.append(aliaser.name(forObject: controller))
            
            if let presentedViewController = controller.presentedViewController {
                joiner.append("presents:\(aliaser.name(forObject: presentedViewController))")
            }
            
            if let presentingViewController = controller.presentingViewController {
                joiner.append("presentedBy:\(aliaser.name(forObject: presentingViewController))")
            }
            
            print(joiner)
            
            seenControllers.insert(controller)
            
        } while !stack.isEmpty
    }
}

public func printRootControllerHierarchy() {
    UIApplication.sharedApplication().windows[0].rootViewController?.printControllerHierarchy()
}
