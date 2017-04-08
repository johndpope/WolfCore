//
//  SequenceExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

extension Sequence where Iterator.Element == String {
    public var spaceSeparated: String {
        return joined(separator: " ")
    }

    public var tabSeparated: String {
        return joined(separator: "\t")
    }

    public var commaSeparated: String {
        return joined(separator: ",")
    }

    public var newlineSeparated: String {
        return joined(separator: "\n")
    }

    public var crlfSeparated: String {
        return joined(separator: "\r\n")
    }
}
