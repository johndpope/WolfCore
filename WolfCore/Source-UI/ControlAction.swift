//
//  ControlAction.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

private let controlActionSelector = #selector(ControlAction.controlAction)

public typealias ControlBlock = (UIControl) -> Void

public class ControlAction: NSObject {
    public var action: ControlBlock?
    private let control: UIControl
    private let controlEvents: UIControlEvents

    public init(control: UIControl, for controlEvents: UIControlEvents, action: ControlBlock? = nil) {
        self.control = control
        self.action = action
        self.controlEvents = controlEvents
        super.init()
        control.addTarget(self, action: controlActionSelector, for: controlEvents)
    }

    deinit {
        control.removeTarget(self, action: controlActionSelector, for: controlEvents)
    }

    public func controlAction() {
        action?(control)
    }
}

extension UIControl {
    public func addControlAction(for controlEvents: UIControlEvents, action: @escaping ControlBlock) -> ControlAction {
        return ControlAction(control: self, for: controlEvents, action: action)
    }

    public func addTouchUpInsideAction(action: @escaping ControlBlock) -> ControlAction {
        return addControlAction(for: .touchUpInside, action: action)
    }

    public func addValueChangedAction(action: @escaping ControlBlock) -> ControlAction {
        return addControlAction(for: .valueChanged, action: action)
    }
}
