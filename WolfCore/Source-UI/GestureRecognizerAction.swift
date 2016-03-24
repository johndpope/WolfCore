//
//  GestureRecognizerAction.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias OSGestureRecognizer = UIGestureRecognizer
#else
    import Cocoa
    public typealias OSGestureRecognizer = NSGestureRecognizer
#endif

private let gestureActionSelector = #selector(GestureRecognizerAction.gestureAction)

public class GestureRecognizerAction: NSObject {
    private let action: DispatchBlock
    private let gestureRecognizer: OSGestureRecognizer
    
    public init(gestureRecognizer: OSGestureRecognizer, action: DispatchBlock) {
        self.gestureRecognizer = gestureRecognizer
        self.action = action
        super.init()
        #if os(iOS)
            gestureRecognizer.addTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = self
            gestureRecognizer.action = gestureActionSelector
        #endif
    }
    
    deinit {
        #if os(iOS)
            gestureRecognizer.removeTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = nil
            gestureRecognizer.action = nil
        #endif
    }
    
    public func gestureAction() {
        action()
    }
}

extension OSView {
    public func addGestureRecognizerAction(gestureRecognizer: OSGestureRecognizer, action: DispatchBlock) -> GestureRecognizerAction {
        self.addGestureRecognizer(gestureRecognizer)
        return GestureRecognizerAction(gestureRecognizer: gestureRecognizer, action: action)
    }
}
