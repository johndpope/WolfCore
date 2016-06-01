//
//  SizeExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 12/21/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(iOS) || os(tvOS)
    import UIKit
#endif

#if os(iOS) || os(tvOS)
    public let noSize = UIViewNoIntrinsicMetric
#else
    public let noSize: CGFloat = -1.0
#endif

extension CGSize {
    public static var none = CGSize(width: noSize, height: noSize)

    public init(vector: CGVector) {
        width = vector.dx
        height = vector.dy
    }

    public var aspect: CGFloat {
        return width / height
    }

    public func scaleForAspectFitWithinSize(size: CGSize) -> CGFloat {
        if size.width != noSize && size.height != noSize {
            return min(size.width / width, size.height / height)
        } else if size.width != noSize {
            return size.width / width
        } else {
            return 1.0
        }
    }

    public func scaleForAspectFillWithinSize(size: CGSize) -> CGFloat {
        if size.width != noSize && size.height != noSize {
            return max(size.width / width, size.height / height)
        } else if size.width != noSize {
            return size.width / width
        } else {
            return 1.0
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

public func + (left: CGSize, right: CGSize) -> CGVector {
    return CGVector(dx: left.width + right.width, dy: left.height + right.height)
}

public func - (left: CGSize, right: CGSize) -> CGVector {
    return CGVector(dx: left.width - right.width, dy: left.height - right.height)
}

public func + (left: CGSize, right: CGVector) -> CGSize {
    return CGSize(width: left.width + right.dx, height: left.height + right.dy)
}

public func - (left: CGSize, right: CGVector) -> CGSize {
    return CGSize(width: left.width - right.dx, height: left.height - right.dy)
}

public func + (left: CGVector, right: CGSize) -> CGSize {
    return CGSize(width: left.dx + right.width, height: left.dy + right.height)
}

public func - (left: CGVector, right: CGSize) -> CGSize {
    return CGSize(width: left.dx - right.width, height: left.dy - right.height)
}
