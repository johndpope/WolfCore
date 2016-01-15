//
//  Rect.swift
//  WolfCore
//
//  Created by Robert McNally on 1/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public struct Rect {
    public var origin: Point
    public var size: Size
    
    public init() {
        origin = Point.zero
        size = Size.zero
    }
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
}

extension Rect {
    public static let zero = Rect()
    public static let null = Rect(origin: .infinite, size: .zero)
    public static let infinite = Rect(origin: Point(x: -Double.infinity, y: -Double.infinity), size: .infinite)
}

extension Rect {
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
    
    public init(x: Float, y: Float, width: Float, height: Float) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
}

extension Rect {
    public var width: Double { return size.width }
    public var height: Double { return size.height }
    public var minX: Double { return origin.x }
    public var midX: Double { return minX + width / 2.0 }
    public var maxX: Double { return minX + width }
    public var minY: Double { return origin.y }
    public var midY: Double { return minY + height / 2.0 }
    public var maxY: Double { return minY + height }
}

extension Rect {
    public var isNull: Bool { return self.origin == .infinite }
    public var isEmpty: Bool { return self.isNull || size.isEmpty }
    public var isInfinite: Bool { return self == .infinite }
}

extension Rect {
    private func standardize(min: Double, extent: Double) -> (min: Double, extent: Double) {
        if min >= 0 {
            return (min, extent)
        } else {
            return
        }
    }
    public var standardized: Rect {
        guard !isNull else { return self }
        guard width < 0.0 || height < 0.0 else { return self }
        
    }
}

extension Rect: Equatable {
}

public func ==(lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}
