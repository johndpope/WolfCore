//
//  TarotCard.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public enum TarotCardTrump: Int, CardTrump {
    case fool = 0
    case magician
    case highPriestess
    case empress
    case emperor
    case hierophant
    case lovers
    case chariot
    case strength
    case hermit
    case wheelOfFortune
    case justice
    case hangedMan
    case death
    case temperance
    case devil
    case tower
    case star
    case moon
    case sun
    case judgement
    case world

    public static let orderedTrumps: [CardTrump] = [
        TarotCardTrump.fool,
        TarotCardTrump.magician,
        TarotCardTrump.highPriestess,
        TarotCardTrump.empress,
        TarotCardTrump.emperor,
        TarotCardTrump.hierophant,
        TarotCardTrump.lovers,
        TarotCardTrump.chariot,
        TarotCardTrump.strength,
        TarotCardTrump.hermit,
        TarotCardTrump.wheelOfFortune,
        TarotCardTrump.justice,
        TarotCardTrump.hangedMan,
        TarotCardTrump.death,
        TarotCardTrump.temperance,
        TarotCardTrump.devil,
        TarotCardTrump.tower,
        TarotCardTrump.star,
        TarotCardTrump.moon,
        TarotCardTrump.sun,
        TarotCardTrump.judgement,
        TarotCardTrump.world
    ]
    
    public static let trumpStrings = [
        "The Fool",
        "The Magician",
        "The High Priestess",
        "The Empress",
        "The Emperor",
        "The Hierophant",
        "The Lovers",
        "The Chariot",
        "Strength",
        "The Hermit",
        "Wheel of Fortune",
        "Justice",
        "The Hanged Man",
        "Death",
        "Temperance",
        "The Devil",
        "The Tower",
        "The Star",
        "The Moon",
        "The Sun",
        "Judgement",
        "The World"
    ]
    
    public static let trumpNumeralStrings = [
        "0",
        "I",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII",
        "XIII",
        "XIV",
        "XV",
        "XVI",
        "XVII",
        "XVIII",
        "XIX",
        "XX",
        "XXI"
    ]
}

extension TarotCardTrump: CustomStringConvertible {
    public var description: String {
        return "\(self.dynamicType.trumpNumeralStrings[rawValue]) - \(self.dynamicType.trumpStrings[rawValue])"
    }
}

public enum TarotCardSuit: Int, CardSuit {
    case swords = 1
    case pentacles
    case wands
    case cups
    
    public static let orderedSuits: [CardSuit] = [TarotCardSuit.swords, TarotCardSuit.pentacles, TarotCardSuit.wands, TarotCardSuit.cups]
    public static let suitStrings = ["Swords", "Pentacles", "Wands", "Cups"]
    public static let suitSymbols = ["🜁", "🜃", "🜂", "🜄"]
}

public enum TarotCardRank: Int, CardRank {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten
    case page, knight, queen, king
    
    public static let orderedRanks: [CardRank] = [TarotCardRank.ace, TarotCardRank.two, TarotCardRank.three, TarotCardRank.four, TarotCardRank.five, TarotCardRank.six, TarotCardRank.seven, TarotCardRank.eight, TarotCardRank.nine, TarotCardRank.ten, TarotCardRank.page, TarotCardRank.knight, TarotCardRank.queen, TarotCardRank.king]
    public static let rankStrings = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]
    public static let rankSuitConnector = " of "
}

extension TarotCardRank: CustomStringConvertible {
    public var description: String {
        return self.dynamicType.rankStrings[rawValue - 1]
    }
}

extension TarotCardSuit: CustomStringConvertible {
    public var description: String {
        return self.dynamicType.suitStrings[rawValue - 1]
    }
}

public typealias TarotCard = Card<TarotCardTrump, TarotCardRank, TarotCardSuit>
public typealias TarotCardPile = Pile<TarotCardTrump, TarotCardRank, TarotCardSuit>

public func newTarotCardDeck() -> TarotCardPile {
    return TarotCardPile.newDeck()
}

