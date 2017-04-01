//
//  JSONModel.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/31/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public protocol JSONModel: CustomStringConvertible {
    init(json: JSON)

    var json: JSON { get }
}

extension JSONModel {
    public var description: String {
        return json.description
    }
}
