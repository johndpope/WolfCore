//
//  AffineTransformUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

extension CGAffineTransform {
    public static var identity: CGAffineTransform {
        return CGAffineTransformIdentity
    }
    
    
    public static func translation(tx: CGFloat, _ ty: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(tx, ty)
    }
    
    public static func scaling(sx: CGFloat, _ sy: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeScale(sx, sy)
    }
    
    public static func rotation(angle: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeRotation(angle)
    }

    
    public func translate(tx: CGFloat, _ ty: CGFloat) -> CGAffineTransform {
        return CGAffineTransformTranslate(self, tx, ty)
    }
    
    public func translate(v: CGVector) -> CGAffineTransform {
        return translate(v.dx, v.dy)
    }
    
    
    public func scale(sx: CGFloat, _ sy: CGFloat) -> CGAffineTransform {
        return CGAffineTransformScale(self, sx, sy)
    }
    
    public func scale(v: CGVector) -> CGAffineTransform {
        return scale(v.dx, v.dy)
    }
    
    
    public func rotate(angle: CGFloat) -> CGAffineTransform {
        return CGAffineTransformRotate(self, angle)
    }
    
    
    public func invert() -> CGAffineTransform {
        return CGAffineTransformInvert(self)
    }
    
    
    public func concat(t: CGAffineTransform) -> CGAffineTransform {
        return CGAffineTransformConcat(self, t)
    }
}