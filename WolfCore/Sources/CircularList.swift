//
//  CircularList.swift
//  WolfCore
//
//  Created by Michael Lee on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

public struct CircularList<T> {
    public typealias ElementType = T

    private var elements = [ElementType]()
    public var currentIndex: Int = 0

    public init(elements: [ElementType]) {
        self.elements = elements
    }

    public subscript(index: Int) -> ElementType? {
        get { return elements.element(atCircularIndex: index) }
        set { elements.replaceElement(atCircularIndex: index, withElement: newValue!) }
    }

    public func currentElement() -> ElementType? {
        guard !elements.isEmpty else { return nil }
        return self[currentIndex]
    }

    public mutating func nextElement() -> ElementType? {
        guard !elements.isEmpty else { return nil }
        currentIndex += 1
        return self[currentIndex]
    }

    public mutating func previousElement() -> ElementType? {
        guard !elements.isEmpty else { return nil }
        currentIndex -= 1
        return self[currentIndex]
    }

    public func element(atOffset offset: Int) -> ElementType? {
        guard !elements.isEmpty else { return nil }
        return self[currentIndex + offset]
    }
}
