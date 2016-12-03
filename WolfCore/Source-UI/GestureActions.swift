//
//  GestureActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif

public class GestureActions {
    unowned let view: UIView
    var gestureRecognizerActions = [String: GestureRecognizerAction]()

    public init(view: UIView) {
        self.view = view
    }

    func getAction(for name: String) -> GestureBlock? {
        return gestureRecognizerActions[name]?.action
    }

    func set(action: @escaping GestureBlock, gestureRecognizer: OSGestureRecognizer, name: String) {
        gestureRecognizerActions[name] = view.addAction(forGestureRecognizer: gestureRecognizer) { recognizer in
            action(recognizer)
        }
    }

    func set(swipeAction action: GestureBlock?, forDirection direction: UISwipeGestureRecognizerDirection, name: String) {
        if let action = action {
            let recognizer = UISwipeGestureRecognizer()
            recognizer.direction = direction
            set(action: action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(for: name)
        }
    }

    func set(pressAction action: GestureBlock?, forPress press: UIPressType, name: String) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            recognizer.allowedPressTypes = [NSNumber(value: press.rawValue)]
            set(action: action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(for: name)
        }
    }

    func set(tapAction action: GestureBlock?, name: String) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            set(action: action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(for: name)
        }
    }

    func removeAction(for name: String) {
        gestureRecognizerActions.removeValue(forKey: name)
    }
}
