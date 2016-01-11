//
//  SizeExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 12/21/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

public let NoSize = UIViewNoIntrinsicMetric

extension CGSize {
    public init(vector: CGVector) {
        width = vector.dx
        height = vector.dy
    }
    
    public var aspect: CGFloat {
        return width / height
    }
    
    public func scaleForAspectFitWithinSize(size: CGSize) -> CGFloat {
        if size.width != NoSize && size.height != NoSize {
            return min(size.width / width, size.height / height)
        } else if size.width != NoSize {
            return size.width / width
        } else {
            return size.height / height
        }
    }
    
    public func scaleForAspectFillWithinSize(size: CGSize) -> CGFloat {
        if size.width != NoSize && size.height != NoSize {
            return max(size.width / width, size.height / height)
        } else if size.width != NoSize {
            return size.width / width
        } else {
            return size.height / height
        }
    }
    
    public func aspectFitWithinSize(size: CGSize) -> CGSize {
        let scale = scaleForAspectFitWithinSize(size)
        return CGSize(vector: CGVector(size: self) * scale)
    }
    
    public func aspectFillWithinSize(size: CGSize) -> CGSize {
        let scale = scaleForAspectFillWithinSize(size)
        return CGSize(vector: CGVector(size: self) * scale)
    }
}
