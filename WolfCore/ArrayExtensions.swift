//
//  ArrayExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/5/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

extension Array {
    public func circularIndex(index: Int) -> Int {
        guard count > 0 else {
            return 0
        }

        let i = index % count
        return i >= 0 ? i : i + count
    }
    
    public func elementAtCircularIndex(index: Int) -> Element {
        return self[circularIndex(index)]
    }
    
    public mutating func replaceElementAtCircularIndex(index: Index, withElement element: Element) {
        self[circularIndex(index)] = element
    }
}
