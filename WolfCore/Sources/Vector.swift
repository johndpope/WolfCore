//
//  Vector.swift
//  WolfCore
//
//  Created by Robert McNally on 1/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(OSX) || os(tvOS)
    import CoreGraphics
#endif

public struct Vector {
    public var dx: Double = 0
    public var dy: Double = 0
}

#if os(iOS) || os(OSX) || os(tvOS)
    extension Vector {
        public init(v: CGVector) {
            dx = Double(v.dx)
            dy = Double(v.dy)
        }
        
        public var cgVector: CGVector {
            return CGVector(dx: CGFloat(dx), dy: CGFloat(dy))
        }
    }
#endif

extension Vector: CustomStringConvertible {
    public var description: String {
        return("Vector(\(dx), \(dy))")
    }
}

extension Vector {
    public static let zero = Vector()
    
    public init(dx: Int, dy: Int) {
        self.dx = Double(dx)
        self.dy = Double(dy)
    }
    
    public init(dx: Float, dy: Float) {
        self.dx = Double(dx)
        self.dy = Double(dy)
    }
}

extension Vector: Equatable {
}

public func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.dx == rhs.dx && lhs.dy == rhs.dy
}
