//
//  Pile.swift
//  WolfCore
//
//  Created by Robert McNally on 4/15/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public class Pile<T: CardTrump, R: CardRank, S: CardSuit> {
    public typealias TrumpType = T
    public typealias RankType = R
    public typealias SuitType = S

    public typealias CardType = Card<TrumpType, RankType, SuitType>

    public var cards = [CardType?]()

    public init() {
    }

    public init(cards: [CardType?]) {
        self.cards = cards
    }

    public init(pile: Pile) {
        cards = pile.cards
    }

    public init(placeholdersCount: Int) {
        cards = [CardType?](repeating: nil, count: placeholdersCount)
    }

    public func shuffled() -> Pile {
        var newCards = [CardType?]()
        var oldCards = cards
        while !oldCards.isEmpty {
            let index = Int(arc4random_uniform(UInt32(oldCards.count)))
            let card = oldCards[index]
            newCards.append(card)
            oldCards.remove(at: index)
        }
        return Pile(cards: newCards)
    }

    public func draw(withFacing facing: CardFacing = .faceDown, isReversed: Bool = false) -> CardType {
        var card = cards[0]!
        card.facing = facing
        card.isReversed = isReversed
        cards.remove(at: 0)
        return card
    }

    public func deal(toPile pile: Pile, count: Int = 1, facing: CardFacing = .faceDown, isReversed: Bool = false) {
        for _ in 1...count {
            pile.cards.insert(draw(withFacing: facing, isReversed: isReversed), at: 0)
        }
    }

    public func deal(toPile pile: Pile, atIndex index: Int, facing: CardFacing = .faceDown, isReversed: Bool = false) {
        pile.cards[index] = draw(withFacing: facing, isReversed: isReversed)
    }

    public subscript(index: Int) -> CardType? {
        return cards[index]
    }

    public func removeAll() {
        cards.removeAll()
    }

    public var count: Int {
        return cards.count
    }
}

extension Pile {
    public var json: JSONDictionary {
        let jsonCards = cards.map { (card) -> JSONObject in
            return card?.json ?? NSNull()
        }
        return [
            "type": "Pile",
            "cards": jsonCards
        ]
    }

    public convenience init(json: JSONDictionary) {
        assert(json["type"] as! String == "Pile")
        let jsonCards = json["cards"] as! JSONArray
        let cards = jsonCards.map { (jsonCard) -> CardType? in
            return jsonCard == NSNull() ? nil : CardType(json: jsonCard as! JSONDictionary)
        }
        self.init(cards: cards)
    }
}

extension Pile: CustomStringConvertible {
    public var description: String {
        var a = [String]()
        for c in cards {
            a.append(c?.description ?? "PLACEHOLDER")
        }
        return "[" + a.joined(separator: ",") + "]"
    }
}

extension Pile {
    public static func newDeck(includeTrumps: Bool = true, includePips: Bool = true) -> Pile {
        var cards = [CardType?]()
        if includeTrumps {
            for trump in CardType.TrumpType.orderedTrumps {
                let t = trump as! TrumpType
                cards.append(CardType(trump: t))
            }
        }
        if includePips {
            for suit in CardType.SuitType.orderedSuits {
                for rank in CardType.RankType.orderedRanks {
                    let r = rank as! RankType
                    let s = suit as! SuitType
                    cards.append(CardType(rank: r, suit: s))
                }
            }
        }
        return Pile(cards: cards)
    }
}
