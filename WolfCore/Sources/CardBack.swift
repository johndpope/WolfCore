//
//  CardBack.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public enum CardBack : String {
    case blue = "Blue"
    case red = "Red"
}

extension CardBack : CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
