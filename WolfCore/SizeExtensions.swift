//
//  SizeExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 12/21/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

extension CGSize {
    public init(vector: CGVector) {
        width = vector.dx
        height = vector.dy
    }
    
    public var aspect: CGFloat {
        return width / height
    }
    
    public func scaleForAspectFitWithinSize(size: CGSize) -> CGFloat {
        return min(size.width / width, size.height / height)
    }
    
    public func scaleForAspectFillWithinSize(size: CGSize) -> CGFloat {
        return max(size.width / width, size.height / height)
    }
    
    public func aspectFitWithinSize(size: CGSize) -> CGSize {
        let scale = scaleForAspectFitWithinSize(size)
        return CGSize(vector: CGVector(size: size) * scale)
    }
    
    public func aspectFillWithinSize(size: CGSize) -> CGSize {
        let scale = scaleForAspectFillWithinSize(size)
        return CGSize(vector: CGVector(size: size) * scale)
    }
}
