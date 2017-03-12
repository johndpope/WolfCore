//
//  Editable.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/11/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public protocol Editable: class {
    var isEditing: Bool { get set }
    func setEditing(_ isEditing: Bool, animated: Bool)
    func syncToEditing(animated: Bool)
}

extension Editable {
    public func setEditing(_ isEditing: Bool, animated: Bool) {
        self.isEditing = isEditing
        syncToEditing(animated: animated)
    }
}
