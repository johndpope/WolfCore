//
//  PlayingCard.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//


public enum PlayingCardTrump: Int, CardTrump {
    case joker = 0

    public static let orderedTrumps: [CardTrump] = [PlayingCardTrump.joker]
    public static let trumpStrings = ["Joker"]
}

extension PlayingCardTrump: CustomStringConvertible {
    public var description: String {
        return self.dynamicType.trumpStrings[rawValue]
    }
}

public enum PlayingCardRank: Int, CardRank {
    case ace = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king

    public static let orderedRanks: [CardRank] = [
        PlayingCardRank.ace,
        PlayingCardRank.two,
        PlayingCardRank.three,
        PlayingCardRank.four,
        PlayingCardRank.five,
        PlayingCardRank.six,
        PlayingCardRank.seven,
        PlayingCardRank.eight,
        PlayingCardRank.nine,
        PlayingCardRank.ten,
        PlayingCardRank.jack,
        PlayingCardRank.queen,
        PlayingCardRank.king
    ]

    public static let rankStrings = [
        "A",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "J",
        "Q",
        "K"
    ]

    public static let rankSuitConnector = ""
}

extension PlayingCardRank: CustomStringConvertible {
    public var description: String {
        return self.dynamicType.rankStrings[rawValue - 1]
    }
}

public enum PlayingCardSuit: Int, CardSuit {
    case spades = 1
    case diamonds
    case clubs
    case hearts

    public static let orderedSuits: [CardSuit] = [PlayingCardSuit.spades, PlayingCardSuit.diamonds, PlayingCardSuit.clubs, PlayingCardSuit.hearts]
    public static let suitStrings = ["Spades", "Diamonds", "Clubs", "Hearts"]
    public static let suitSymbols = ["♠️", "♦️", "♣️", "♥️"]
}

extension PlayingCardSuit: CustomStringConvertible {
    public var description: String {
        return self.dynamicType.suitSymbols[rawValue - 1]
    }
}

public typealias PlayingCard = Card<PlayingCardTrump, PlayingCardRank, PlayingCardSuit>
public typealias PlayingCardPile = Pile<PlayingCardTrump, PlayingCardRank, PlayingCardSuit>

public func newPlayingCardDeck() -> PlayingCardPile {
    return PlayingCardPile.newDeck(includeTrumps: false)
}
