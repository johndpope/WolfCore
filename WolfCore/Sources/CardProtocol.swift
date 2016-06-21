//
//  CardProtocol.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol CardProtocol: CustomStringConvertible {
    var facing: CardFacing { get set }
    var isReversed: Bool { get set }
    var json: JSON.Dictionary { get }
    init(json: JSON.Dictionary)
}
