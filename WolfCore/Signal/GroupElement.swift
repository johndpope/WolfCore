//
//  GroupElement.swift
//  WolfCore
//
//  Created by Robert McNally on 7/11/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

/// x == X / Z; y == Y / Z
public struct GroupElementProjective {
    public let x: FieldElement
    public let y: FieldElement
    public let z: FieldElement

    public init(x: FieldElement, y: FieldElement, z: FieldElement) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(_ p: GroupElementExtended) {
        x = p.x
        y = p.y
        z = p.z
    }

    /// monadic transformer
    public static func to(_ p: GroupElementExtended) -> GroupElementProjective {
        return GroupElementProjective(p)
    }

    public init(_ p: GroupElementCompleted) {
        x = p.x * p.t
        y = p.y * p.z
        z = p.z * p.t
    }

    /// monadic transformer
    public static func to(_ p: GroupElementCompleted) -> GroupElementProjective {
        return GroupElementProjective(p)
    }

    public static let zero = GroupElementProjective(x: FieldElement.zero, y: FieldElement.one, z: FieldElement.one)

    /// monadic transformer
    public static func toData(h: GroupElementProjective) -> Data {
        let reciprocal = h.z |> FieldElement.inverted
        let x = h.x * reciprocal
        let y = h.y * reciprocal
        var s = y |> FieldElement.toData
        s[31] ^= Byte(x.oneIfNegative << 7)
        return s
    }
}

/// x == X / Z; y == y / Z; X * Y == Z * T
public struct GroupElementExtended {
    public let x: FieldElement
    public let y: FieldElement
    public let z: FieldElement
    public let t: FieldElement

    public init(x: FieldElement, y: FieldElement, z: FieldElement, t: FieldElement) {
        self.x = x
        self.y = y
        self.z = z
        self.t = t
    }

    public init(_ p: GroupElementCompleted) {
        x = p.x * p.t
        y = p.y * p.z
        z = p.z * p.t
        t = p.x * p.y
    }

    public static let zero = GroupElementExtended(x: FieldElement.zero, y: FieldElement.one, z: FieldElement.one, t: FieldElement.zero)

    /// monadic transformer
    public static func toData(h: GroupElementExtended) -> Data {
        let reciprocal = h.z |> FieldElement.inverted
        let x = h.x * reciprocal
        let y = h.y * reciprocal
        var s = y |> FieldElement.toData
        s[31] ^= Byte(x.oneIfNegative << 7)
        return s
    }
}

/// x == X / Z; y == Y / T
public struct GroupElementCompleted {
    public let x: FieldElement
    public let y: FieldElement
    public let z: FieldElement
    public let t: FieldElement

    public static func added(_ p: GroupElementExtended, _ q: GroupElementCached) -> GroupElementCompleted {
        let yPlusX = p.y + p.x
        let yMinusX = p.y - p.x
        let a = yPlusX * q.yPlusX
        let b = yMinusX * q.yMinusX
        let c = q.td2 * p.t
        let zz = p.z * q.z
        let d = zz + zz
        let x3 = a - b
        let y3 = a + b
        let z3 = d + c
        let t3 = d - c
        return GroupElementCompleted(x: x3, y: y3, z: z3, t: t3)
    }

    public static func added(_ p: GroupElementExtended, _ q: GroupElementPrecomp) -> GroupElementCompleted {
        let yPlusX = p.y + p.x
        let yMinusX = p.y - p.x
        let a = yPlusX * q.yPlusX
        let b = yMinusX * q.yMinusX
        let c = q.xyd2 * p.t
        let d = p.z + p.z
        let x3 = a - b
        let y3 = a + b
        let z3 = d + c
        let t3 = d - c
        return GroupElementCompleted(x: x3, y: y3, z: z3, t: t3)
    }

    public static func subtracted(_ p: GroupElementExtended, _ q: GroupElementCached) -> GroupElementCompleted {
        let yPlusX = p.y + p.x
        let yMinusX = p.y - p.x
        let a = yPlusX * q.yMinusX
        let b = yMinusX * q.yPlusX
        let c = q.td2 * p.t
        let zz = p.z * q.z
        let d = zz + zz
        let x3 = a - b
        let y3 = a + b
        let z3 = d - c
        let t3 = d + c
        return GroupElementCompleted(x: x3, y: y3, z: z3, t: t3)
    }

    public static func subtracted(_ p: GroupElementExtended, _ q: GroupElementPrecomp) -> GroupElementCompleted {
        let yPlusX = p.y + p.x
        let yMinusX = p.y - p.x
        let a = yPlusX * q.yMinusX
        let b = yMinusX * q.yPlusX
        let c = q.xyd2 * p.t
        let d = p.z + p.z
        let x3 = a - b
        let y3 = a + b
        let z3 = d - c
        let t3 = d + c
        return GroupElementCompleted(x: x3, y: y3, z: z3, t: t3)
    }

    /// monadic transformer
    public static func doubled(_ p: GroupElementProjective) -> GroupElementCompleted {
        let xx = p.x |> FieldElement.squared
        let yy = p.y |> FieldElement.squared
        let b = p.z |> FieldElement.squaredAndMultipliedBy2
        let a = p.x + p.y
        let aa = a |> FieldElement.squared
        let y3 = yy + xx
        let z3 = yy - xx
        let x3 = aa - y3
        let t3 = b - z3
        return GroupElementCompleted(x: x3, y: y3, z: z3, t: t3)
    }

    /// monadic transformer
    public static func doubled(_ p: GroupElementExtended) -> GroupElementCompleted {
        return p |> GroupElementProjective.to |> doubled
    }
}

/// y + x; y - x; x * y * d * 2
public struct GroupElementPrecomp {
    public let yPlusX: FieldElement
    public let yMinusX: FieldElement
    public let xyd2: FieldElement

    public static let zero = GroupElementPrecomp(yPlusX: FieldElement.one, yMinusX: FieldElement.one, xyd2: FieldElement.zero)
}

public struct GroupElementCached {
    public let yPlusX: FieldElement
    public let yMinusX: FieldElement
    public let z: FieldElement
    public let td2: FieldElement

    public init(yPlusX: FieldElement, yMinusX: FieldElement, z: FieldElement, td2: FieldElement) {
        self.yPlusX = yPlusX
        self.yMinusX = yMinusX
        self.z = z
        self.td2 = td2
    }

    public init(p: GroupElementExtended) {
        yPlusX = p.y + p.x
        yMinusX = p.y - p.x
        z = p.z
        td2 = p.t * FieldElement.d2
    }
}
