//
//  GestureRecognizerAction.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

private let gestureActionSelector = Selector("gestureAction")

public class GestureRecognizerAction: NSObject {
    private let action: DispatchBlock
    private let gestureRecognizer: UIGestureRecognizer
    
    public init(gestureRecognizer: UIGestureRecognizer, action: DispatchBlock) {
        self.gestureRecognizer = gestureRecognizer
        self.action = action
        super.init()
        gestureRecognizer.addTarget(self, action: gestureActionSelector)
    }
    
    deinit {
        gestureRecognizer.removeTarget(self, action: gestureActionSelector)
    }
    
    public func gestureAction() {
        action()
    }
}

extension UIView {
    public func addGestureRecognizerAction(gestureRecognizer: UIGestureRecognizer, action: DispatchBlock) -> GestureRecognizerAction {
        self.addGestureRecognizer(gestureRecognizer)
        return GestureRecognizerAction(gestureRecognizer: gestureRecognizer, action: action)
    }
}
