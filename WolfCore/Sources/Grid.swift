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
    
    public func get(point: IntPoint) throws -> T {
        try checkCoodinateValid(point)
        return rows[point.y][point.x]
    }
    
    public func set(point: IntPoint, value: T) throws {
        try checkCoodinateValid(point)
        rows[point.y][point.x] = value
    }
    
    public func getCircular(point: IntPoint) -> T {
        let cx = circularIndex(point.y, count: size.height)
        let cy = circularIndex(point.x, count: size.width)
        return try! get(IntPoint(x: cx, y: cy))
    }
    
    public func setCircular(point: IntPoint, value: T) {
        let cx = circularIndex(point.y, count: size.height)
        let cy = circularIndex(point.x, count: size.width)
        try! set(IntPoint(x: cx, y: cy), value: value)
    }
    
    public func forAll(f: (IntPoint) -> Void) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                f(IntPoint(x: x, y: y))
            }
        }
    }
    
    public func setAll(value: T) {
        forAll { p in
            self[p] = value
        }
    }
    
    public func forNeighborhoodAtPoint(point: IntPoint, f: (o: IntPoint, p: IntPoint) -> Void) {
        for oy in -1..<1 {
            for ox in -1..<1 {
                let o = IntPoint(x: ox, y: oy)
                let p = IntPoint(x: circularIndex(ox + point.x, count: size.width), y: circularIndex(oy + point.y, count: size.height))
                f(o: o, p: p)
            }
        }
    }
    
    public subscript(point: IntPoint) -> T {
        get { return try! self.get(point) }
        set { try! self.set(point, value: newValue) }
    }
    
    public subscript(x: Int, y: Int) -> T {
        get { return self[IntPoint(x: x, y: y)] }
        set { self[IntPoint(x: x, y: y)] = newValue }
    }
    
    public func equals(g: Grid<T>) -> Bool {
        guard size == g.size else { return false }
        return true
    }
    
    public var stringRepresentation: String {
        return rows.map { $0.map { return "\($0)" }.joinWithSeparator(" ") }.joinWithSeparator("\n")
    }
    
    public func print() {
        Swift.print(stringRepresentation)
    }
}

public func ==<T>(lhs: Grid<T>, rhs: Grid<T>) -> Bool {
    return lhs.equals(rhs)
}