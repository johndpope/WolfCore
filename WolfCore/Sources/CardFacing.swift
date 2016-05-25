//
//  CardFacing.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public enum CardFacing {
    case faceUp
    case faceDown

    public var flipped: CardFacing {
        switch self {
        case .faceUp:
            return .faceDown
        case .faceDown:
            return .faceUp
        }
    }

    public var facingString: String {
        switch self {
        case .faceUp:
            return ""
        case .faceDown:
            return "🂠"
        }
    }
}

extension CardFacing : CustomStringConvertible {
    public var description: String {
        return facingString
    }
}
