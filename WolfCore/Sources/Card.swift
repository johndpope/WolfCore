//
//  Card.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public protocol CardTrump {
    var rawValue: Int { get }
    init?(rawValue: Int)

    static var orderedTrumps: [CardTrump] { get }
}

public protocol CardRank {
    var rawValue: Int { get }
    init?(rawValue: Int)

    static var orderedRanks: [CardRank] { get }
    static var rankSuitConnector: String { get }
}

public protocol CardSuit {
    var rawValue: Int { get }
    init?(rawValue: Int)

    static var orderedSuits: [CardSuit] { get }
}

public struct Card<T: CardTrump, R: CardRank, S: CardSuit> : CardProtocol {
    public typealias TrumpType = T
    public typealias RankType = R
    public typealias SuitType = S

    public typealias PileType = Pile<TrumpType, RankType, SuitType>

    public let trump: TrumpType?
    public let rank: RankType?
    public let suit: SuitType?
    public let back: CardBack
    public var facing: CardFacing
    public var isReversed: Bool

    init(trump: TrumpType?, rank: RankType?, suit: SuitType?, back: CardBack = .blue, facing: CardFacing = .faceUp, isReversed: Bool = false) {
        self.trump = trump
        self.rank = rank
        self.suit = suit
        self.back = back
        self.facing = facing
        self.isReversed = isReversed
    }

    public init(trump: TrumpType, back: CardBack = .blue, facing: CardFacing = .faceUp, isReversed: Bool = false) {
        self.init(trump: trump, rank: nil, suit: nil, back: back, facing: facing, isReversed: isReversed)
    }

    public init(rank: RankType, suit: SuitType, back: CardBack = .blue, facing: CardFacing = .faceUp, isReversed: Bool = false) {
        self.init(trump: nil, rank: rank, suit: suit, back: back, facing: facing, isReversed: isReversed)
    }

    public func flipped() -> Card {
        return Card(trump: trump, rank: rank, suit: suit, back: back, facing: facing.flipped, isReversed: isReversed)
    }

    public func reversed() -> Card {
        return Card(trump: trump, rank: rank, suit: suit, back: back, facing: facing, isReversed: !isReversed)
    }

    public mutating func flip() {
        self = flipped()
    }

    public mutating func reverse() {
        self = reversed()
    }

    public func turned(toFacing facing: CardFacing) -> Card {
        return Card(trump: trump, rank: rank, suit: suit, back: back, facing: facing, isReversed: isReversed)
    }

    public func turned(toReverse isReversed: Bool) -> Card {
        return Card(trump: trump, rank: rank, suit: suit, back: back, facing: facing, isReversed: isReversed)
    }

    public mutating func turn(toFacing facing: CardFacing) -> Bool {
        if self.facing != facing {
            self = turned(toFacing: facing)
            return true
        } else {
            return false
        }
    }

    public mutating func turn(toReverse isReverse: Bool) -> Bool {
        if self.isReversed != isReversed {
            self = turned(toReverse: isReverse)
            return true
        } else {
            return false
        }
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        let joiner = Joiner()
        if let trump = trump {
            joiner.append(trump)
        }

        var rankSuit = ""

        if let rank = rank {
            rankSuit.append("\(rank)")
        }
        if rank != nil && suit != nil {
            rankSuit.append(RankType.rankSuitConnector)
        }
        if let suit = suit {
            rankSuit.append("\(suit)")
        }

        if !rankSuit.isEmpty {
            joiner.append(rankSuit)
        }

        if facing != .faceUp {
            joiner.append(facing)
        }
        if isReversed {
            joiner.append("reversed")
        }
        if back != .blue {
            joiner.append(back)
        }
        return joiner.description
    }
}

extension Card {
    public var json: JSON.Dictionary {
        var dict: JSON.Dictionary = [
            "type": "Card",
            "back" : back.rawValue,
            "faceUp" : facing == .faceUp
        ]
        if let trump = trump {
            dict["trump"] = trump.rawValue
        }
        if let rank = rank {
            dict["rank"] = rank.rawValue
        }
        if let suit = suit {
            dict["suit"] = suit.rawValue
        }
        if isReversed {
            dict["isReversed"] = true
        }
        return dict
    }

    public init(json: JSON.Dictionary) {
        assert(json["type"] as! String == "Card")

        var trump: TrumpType? = nil
        var rank: RankType? = nil
        var suit: SuitType? = nil

        if let trumpValue = json["trump"] as? Int {
            trump = TrumpType(rawValue: trumpValue)
        } else {
            if let rankValue = json["rank"] as? Int {
                rank = RankType(rawValue: rankValue)
            }
            if let suitValue = json["suit"] as? Int {
                suit = SuitType(rawValue: suitValue)
            }
        }

        let back = CardBack(rawValue: json["back"] as! String)!
        let isReversed = json["isReversed"] as? Bool ?? false
        let facing: CardFacing = (json["faceUp"] as? Bool ?? false) ? .faceUp : .faceDown

        self.init(trump: trump, rank: rank, suit: suit, back: back, facing: facing, isReversed: isReversed)
    }
}
