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

    func getAction(forName name: String) -> GestureBlock? {
        return gestureRecognizerActions[name]?.action
    }

    func set(action: GestureBlock, gestureRecognizer: OSGestureRecognizer, name: String) {
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
            removeAction(forName: name)
        }
    }

    func set(pressAction action: GestureBlock?, forPress press: UIPressType, name: String) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            recognizer.allowedPressTypes = [press.rawValue]
            set(action: action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(forName: name)
        }
    }

    func set(tapAction action: GestureBlock?, name: String) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            set(action: action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(forName: name)
        }
    }

    func removeAction(forName name: String) {
        gestureRecognizerActions.removeValue(forKey: name)
    }
}
