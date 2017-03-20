//
//  GestureRecognizerAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias OSGestureRecognizer = UIGestureRecognizer
#else
    import Cocoa
    public typealias OSGestureRecognizer = NSGestureRecognizer
#endif

private let gestureActionSelector = #selector(GestureRecognizerAction.gestureAction)

public typealias GestureBlock = (OSGestureRecognizer) -> Void

public class GestureRecognizerAction: NSObject, UIGestureRecognizerDelegate {
    public var action: GestureBlock?
    public let gestureRecognizer: OSGestureRecognizer
    public var shouldReceiveTouch: ((UITouch) -> Bool)?

    public init(gestureRecognizer: OSGestureRecognizer, action: GestureBlock? = nil) {
        self.gestureRecognizer = gestureRecognizer
        self.action = action
        super.init()
        #if os(iOS) || os(tvOS)
            gestureRecognizer.addTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = self
            gestureRecognizer.action = gestureActionSelector
        #endif
        gestureRecognizer.delegate = self
    }

    deinit {
        #if os(iOS) || os(tvOS)
            gestureRecognizer.removeTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = nil
            gestureRecognizer.action = nil
        #endif
    }

    public func gestureAction() {
        action?(gestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return shouldReceiveTouch?(touch) ?? true
    }
}

extension OSView {
    public func addAction<G: OSGestureRecognizer>(forGestureRecognizer gestureRecognizer: G, action: @escaping (G) -> Void) -> GestureRecognizerAction {
        self.addGestureRecognizer(gestureRecognizer)
        return GestureRecognizerAction(gestureRecognizer: gestureRecognizer as OSGestureRecognizer, action: { recognizer in
            action(recognizer as! G)
            }
        )
    }
}
