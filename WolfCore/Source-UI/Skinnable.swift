//
//  Skinnable.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

//public protocol Appearable: UIAppearanceContainer {
//}

public protocol Skinnable: UIAppearanceContainer {
    var mySkin: Skin? { get set }
    func updateAppearance(skin: Skin?)
}

/*
 From UIResponder.next

 The UIResponder class does not store or set the next responder automatically, instead returning nil by default. Subclasses must override this method to set the next responder. UIView implements this method by returning the UIViewController object that manages it (if it has one) or its superview (if it doesn’t); UIViewController implements the method by returning its view’s superview; UIWindow returns the application object, and UIApplication returns nil.
 */

extension UIAppearanceContainer {
    public var inheritedSkin: Skin? {
        var current: UIAppearanceContainer! = self

        repeat {
            if let viewController = current as? UIViewController {
                current = viewController.parent
            } else if let view = current as? UIView {
                if let managingViewController = view.next as? UIViewController {
                    current = managingViewController
                } else if let superview = view.superview {
                    current = superview
                } else {
                    current = nil
                }
            } else {
                current = nil
            }
            if let skin = (current as? Skinnable)?.mySkin {
                return skin
            }
        } while current != nil

        return skin
    }
}

extension UIAppearanceContainer {
    public func updateAppearanceContainer(skin: Skin?) {
        guard let skin = skin else { return }

        if let viewController = self as? UIViewController {
            if let skinnable = viewController as? Skinnable {
                skinnable.updateAppearance(skin: skin)
            }

            if viewController.isViewLoaded {
                let view = viewController.view!
                if let skinnable = view as? Skinnable {
                    skinnable.updateAppearance(skin: skin)
                }
                view.updateAppearanceContainer(skin: skin)
            }
        } else if let view = self as? UIView {
            for subview in view.subviews {
                if let skinnable = subview as? Skinnable {
                    skinnable.updateAppearance(skin: skin)
                }
                subview.updateAppearanceContainer(skin: skin)
            }
        }
    }
}
