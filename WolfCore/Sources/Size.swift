//
//  Size.swift
//  WolfCore
//
//  Created by Robert McNally on 1/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import CoreGraphics
#endif

public struct Size {
    public var width: Double
    public var height: Double

    public static let None = -1.0

    public init() {
        width = 0.0
        height = 0.0
    }

    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}

#if os(iOS) || os(OSX) || os(tvOS)
    extension Size {
        public init(s: CGSize) {
            width = Double(s.width)
            height = Double(s.height)
        }

        public var cgSize: CGSize {
            return CGSize(width: Double(width), height: CGFloat(height))
        }
    }
#endif

extension Size {
    public init(vector: Vector) {
        width = vector.dx
        height = vector.dy
    }

    public var aspect: Double {
        return width / height
    }

    public func scaleForAspectFitWithinSize(size: Size) -> Double {
        if size.width != Size.None && size.height != Size.None {
            return min(size.width / width, size.height / height)
        } else if size.width != Size.None {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func scaleForAspectFillWithinSize(size: Size) -> Double {
        if size.width != Size.None && size.height != Size.None {
            return max(size.width / width, size.height / height)
        } else if size.width != Size.None {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func aspectFitWithinSize(size: Size) -> Size {
        let scale = scaleForAspectFitWithinSize(size)
        return Size(vector: Vector(size: self) * scale)
    }

    public func aspectFillWithinSize(size: Size) -> Size {
        let scale = scaleForAspectFillWithinSize(size)
        return Size(vector: Vector(size: self) * scale)
    }
}

extension Size: CustomStringConvertible {
    public var description: String {
        return("Size(\(width), \(height))")
    }
}

extension Size {
    public static let zero = Size()
    public static let infinite = Size(width: Double.infinity, height: Double.infinity)

    public init(width: Int, height: Int) {
        self.width = Double(width)
        self.height = Double(height)
    }

    public init(width: Float, height: Float) {
        self.width = Double(width)
        self.height = Double(height)
    }
}

extension Size : Equatable {
}

public func ==(lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

extension Size {
    public var isEmpty: Bool { return width == 0.0 || height == 0.0 }
}
