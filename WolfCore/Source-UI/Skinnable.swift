//
//  Skinnable.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public protocol Skinnable {
    func updateAppearance(skin: Skin?)
}

public var defaultSkin = DefaultSkin() {
    didSet {
        syncToDefaultSkin()
    }
}

public func syncToDefaultSkin() {
    let barButtonStyle = defaultSkin.fontStyles[.barbuttonTitle]!
    UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : barButtonStyle.font], for: .normal)
}

fileprivate struct AssociatedKeys {
    static var skin = "WolfCore_skin"
}

public func shortName(of skin: Skin?) -> String {
    if skin == nil {
        return "nil"
    } else {
        return (skin†).components(separatedBy: ".").last!
    }
}

extension UIView {
    fileprivate var privateSkin: Skin? {
        get {
            return getAssociatedValue(for: &AssociatedKeys.skin)
        }

        set {
            setAssociatedValue(newValue, for: &AssociatedKeys.skin)
        }
    }

    public var skin: Skin! {
        get {
            if let s = privateSkin {
                return s
            } else if let s = superview?.skin {
                return s
            } else {
                return defaultSkin
            }
        }

        set {
            set(skin: newValue)
        }
    }

    fileprivate func set(skin: Skin!, level: Int = 0) {
        logTrace("\(tabs(level))💟 💖 \(shortName(of: skin)) ⏩ \(self††))", group: .skin)

        if privateSkin?.id != skin?.id {
            privateSkin = skin
            let s = skin ?? self.skin
            UIView.propagate(skin: s, to: self, level: level + 1)
        }
    }

    fileprivate static func propagate(skin: Skin!, to view: UIView, level: Int = 0) {
        guard typeName(of: view) != "_UILayoutGuide" else { return }

        if let skinnable = view as? Skinnable {
            logTrace("\(tabs(level))💟 💚 \(view††) to \(shortName(of: skin))", group: .skin)
            skinnable.updateAppearance(skin: skin)
        } else {
            logTrace("\(tabs(level))💟 🖤 \(view††)", group: .skin)
        }

        for subview in view.subviews {
            if let subviewSkin = subview.privateSkin {
                logTrace("\(tabs(level + 1))💟 ⛔️ \(subview††) has \(shortName(of: subviewSkin))", group: .skin)
            } else {
                propagate(skin: skin, to: subview, level: level + 1)
            }
        }
    }

    public func propagateSkin(why: String) {
        let skin = self.skin
        logTrace("💟 [\(why)] \(shortName(of: skin)) ⏩ \(self††)", group: .skin)
        UIView.propagate(skin: skin, to: self, level: 1)
    }
}

extension UIViewController {
    fileprivate var privateSkin: Skin? {
        get {
            return getAssociatedValue(for: &AssociatedKeys.skin)
        }

        set {
            setAssociatedValue(newValue, for: &AssociatedKeys.skin)
        }
    }

    public var skin: Skin! {
        get {
//            if let c = childViewControllerForStatusBarStyle {
//                return c.skin
//            } else
            if let s = privateSkin {
                return s
            } else {
                return defaultSkin
            }
        }

        set {
            set(skin: newValue)
        }
    }

    fileprivate func set(skin: Skin!, level: Int = 0) {
        logTrace("\(tabs(level))📳 💖 \(shortName(of: skin)) ⏩ \(self††)", group: .skin)

        if privateSkin?.id != skin?.id {
            privateSkin = skin
            let s = skin ?? self.skin
            propagate(skin: s, level: level + 1)
        }
    }

    fileprivate func propagate(skin: Skin!, level: Int = 0) {
        if let skinnable = self as? Skinnable {
            logTrace("\(tabs(level))📳 💚 \(self††)", group: .skin)
            skinnable.updateAppearance(skin: skin)
        } else {
            logTrace("\(tabs(level))📳 🖤 \(self††)", group: .skin)
        }

        if isViewLoaded {
            view!.set(skin: skin, level: level + 1)
        } else {
            logTrace("\(tabs(level))📳 ⛔️ not loaded", group: .skin)
        }
    }

    public func propagateSkin(why: String) {
        let skin = self.skin
        logTrace("📳 [\(why)] \(shortName(of: skin)) ⏩ \(self††)", group: .skin)
        propagate(skin: skin, level: 1)
    }
}
