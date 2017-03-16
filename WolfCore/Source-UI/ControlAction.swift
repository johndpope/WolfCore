//
//  ControlAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

private let controlActionSelector = #selector(ControlAction.controlAction)


public class ControlAction<C: UIControl>: NSObject {
    public typealias ControlType = C
    public typealias ResponseBlock = (ControlType) -> Void

    public var action: ResponseBlock?
    public let control: ControlType
    private let controlEvents: UIControlEvents

    public init(control: ControlType, for controlEvents: UIControlEvents, action: ResponseBlock? = nil) {
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

public func addControlAction<ControlType: UIControl>(to control: ControlType, for controlEvents: UIControlEvents, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return ControlAction(control: control, for: controlEvents, action: action)
}

public func addTouchUpInsideAction<ControlType: UIControl>(to control: ControlType, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return addControlAction(to: control, for: .touchUpInside, action: action)
}

public func addValueChangedAction<ControlType: UIControl>(to control: ControlType, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return addControlAction(to: control, for: .valueChanged, action: action)
}
