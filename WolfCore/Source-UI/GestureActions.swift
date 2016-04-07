//
//  GestureActions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS)
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
    
    func setAction(action: GestureBlock, gestureRecognizer: OSGestureRecognizer, name: String) {
        gestureRecognizerActions[name] = view.addAction(forGestureRecognizer: gestureRecognizer) { recognizer in
            action(recognizer)
        }
    }
    
    func setSwipeAction(action: GestureBlock?, forDirection direction: UISwipeGestureRecognizerDirection, name: String) {
        if let action = action {
            let recognizer = UISwipeGestureRecognizer()
            recognizer.direction = direction
            setAction(action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(forName: name)
        }
    }
    
    func setPressAction(action: GestureBlock?, forPress press: UIPressType, name: String) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            recognizer.allowedPressTypes = [press.rawValue]
            setAction(action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(forName: name)
        }
    }
    
    func setTapAction(action: GestureBlock?, name: String) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            setAction(action, gestureRecognizer: recognizer, name: name)
        } else {
            removeAction(forName: name)
        }
    }
    
    func removeAction(forName name: String) {
        gestureRecognizerActions.removeValueForKey(name)
    }
}
