//
//  ControlAction.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

private let controlActionSelector = #selector(ControlAction.controlAction)

public class ControlAction: NSObject {
    private let action: DispatchBlock
    private let control: UIControl
    private let controlEvents: UIControlEvents
    
    public init(control: UIControl, forControlEvents controlEvents: UIControlEvents, action: DispatchBlock) {
        self.control = control
        self.action = action
        self.controlEvents = controlEvents
        super.init()
        control.addTarget(self, action: controlActionSelector, forControlEvents: controlEvents)
    }
    
    deinit {
        control.removeTarget(self, action: controlActionSelector, forControlEvents: controlEvents)
    }
    
    public func controlAction() {
        action()
    }
}

extension UIControl {
    public func addControlAction(forControlEvents controlEvents: UIControlEvents, action: DispatchBlock) -> ControlAction {
        return ControlAction(control: self, forControlEvents: controlEvents, action: action)
    }
}
