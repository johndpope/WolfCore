//
//  SequenceExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 4/1/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

extension SequenceType where Generator.Element == String {
    public var spaceSeparated: String {
        return joinWithSeparator(" ")
    }
    
    public var tabSeparated: String {
        return joinWithSeparator("\t")
    }
    
    public var commaSeparated: String {
        return joinWithSeparator(",")
    }
    
    public var newlineSeparated: String {
        return joinWithSeparator("\n")
    }
    
    public var crlfSeparated: String {
        return joinWithSeparator("\r\n")
    }
}
