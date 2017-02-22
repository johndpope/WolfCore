//
//  ModelView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/21/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

open class ModelView<M>: View, ModelObject {
    public typealias Model = M
    public typealias ModelBlock = (Model) -> Void
    private lazy var gestureActions: ViewGestureActions = {
        return ViewGestureActions(view: self)
    }()

    public var model: Model! {
        didSet {
            syncToModel()
        }
    }

    open func syncToModel() {
    }

    public init(model: Model) {
        super.init(frame: .zero)
        self.model = model
        syncToModel()
    }

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var onTap: ModelBlock? {
        didSet {
            if onTap != nil {
                gestureActions.onTap = { [unowned self] _ in
                    self.onTap?(self.model)
                }
            } else {
                gestureActions.onTap = nil
            }
        }
    }
}
