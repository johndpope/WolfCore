//
//  ArrayExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

extension Array {
    public func index(withCircularIndex i: Int) -> Int {
        return circularIndex(i, count: count)
    }

    public func element(atCircularIndex i: Int) -> Element {
        return self[index(withCircularIndex: i)]
    }

    public mutating func replaceElement(atCircularIndex i: Index, withElement element: Element) {
        self[index(withCircularIndex: i)] = element
    }
}

extension Array {
    public func split(by size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map { start in
            let end = self.index(start, offsetBy: size, limitedBy: self.count) ?? self.endIndex
            return Array(self[start ..< end])
        }
    }
}

public func circularIndex(_ index: Int, count: Int) -> Int {
    guard count > 0 else {
        return 0
    }

    let i = index % count
    return i >= 0 ? i : i + count
}
