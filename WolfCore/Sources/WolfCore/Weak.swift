//
//  Weak.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/28/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public struct Weak<T> where T: AnyObject {
    public typealias Element = T
    public weak var element: Element?
}
