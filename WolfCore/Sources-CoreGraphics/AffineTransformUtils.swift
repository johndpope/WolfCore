//
//  AffineTransformUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

extension CGAffineTransform {
    public init(scaling s: CGVector) {
        self.init(scaleX: s.dx, y: s.dy)
    }

    public init(translation t: CGVector) {
        self.init(translationX: t.dx, y: t.dy)
    }

    public func scale(by v: CGVector) -> CGAffineTransform {
        return scaleBy(x: v.dx, y: v.dy)
    }

    public func translate(by v: CGVector) -> CGAffineTransform {
        return translateBy(x: v.dx, y: v.dy)
    }
}
