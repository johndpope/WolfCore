//
//  GestureRecognizerAction.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
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

public class GestureRecognizerAction: NSObject {
    public var action: GestureBlock?
    private let gestureRecognizer: OSGestureRecognizer

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
}

extension OSView {
    public func addAction(forGestureRecognizer gestureRecognizer: OSGestureRecognizer, action: GestureBlock) -> GestureRecognizerAction {
        self.addGestureRecognizer(gestureRecognizer)
        return GestureRecognizerAction(gestureRecognizer: gestureRecognizer, action: action)
    }
}
