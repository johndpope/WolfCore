//
//  Grid.swift
//  WolfCore
//
//  Created by Robert McNally on 1/20/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public class Grid<T: Equatable>: Equatable {
    public let size: IntSize
    public var maxX: Int { return size.width - 1 }
    public var maxY: Int { return size.height - 1 }
    private(set) var rows: [[T]]
    
    public init(size: IntSize, initialValue: T) {
        self.size = size
        let row = [T](count: size.width, repeatedValue: initialValue)
        rows = [[T]](count: size.height, repeatedValue: row)
    }
    
    public func isCoordinateValid(point: IntPoint) -> Bool {
        guard point.x >= 0 else { return false }
        guard point.y >= 0 else { return false }
        guard point.x < size.width else { return false }
        guard point.y < size.height else { return false }
        return true
    }
    
    public func checkCoodinateValid(point: IntPoint) throws {
        guard isCoordinateValid(point) else { throw GeneralError(message: "Invalid coordinate: \(point)") }
    }

    public func get(point: Point) throws -> T {
        try checkCoodinateValid(point)
        return rows[Int(point.y)][Int(point.x)]
    }
    
    public func set(point: Point, value: T) throws {
        try checkCoodinateValid(point)
        rows[Int(point.y)][Int(point.x)] = value
    }
    
    public func equals(g: Grid<T>) -> Bool {
        guard width == g.width else { return false }
        guard height == g.height else { return false }
        return true
    }
}

public func ==<T>(lhs: Grid<T>, rhs: Grid<T>) -> Bool {
    return lhs.equals(rhs)
}