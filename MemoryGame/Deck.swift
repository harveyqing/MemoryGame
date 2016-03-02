//
//  Deck.swift
//  MemoryGame
//
//  Created by qingtian on 16/2/27.
//  Copyright © 2016年 qingtian. All rights reserved.
//

import UIKit


struct Deck {
    private var cards = [Card]()
    
    static func full() -> Deck {
        var deck = Deck()
        
        for rank in Rank.Ace.rawValue...Rank.King.rawValue {
            for suit in [Suit.Spades, .Hearts, .Clubs, .Diamonds] {
                let card = Card(rank: Rank(rawValue: rank)!, suit: suit)
                deck.cards.append(card) 
            }
        }
        return deck
    }
    
    // Fisher-Yates (fast and uniform) shuffle
    func shuffled() -> Deck {
        var list = cards
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            guard i != j else {continue}
            swap(&list[i], &list[j])
        }
        
        return Deck(cards: list)
    }
    
    // A subset of Deck
    func deckOfNumberOfCards(num: Int) -> Deck {
        return Deck(cards: Array(cards[0..<num]))
    }
    
    var count: Int {
        get {
            return cards.count
        }
    }
    
    subscript(index: Int) -> Card {
        get {
            return cards[index]
        }
    }
}

func + (deck1: Deck, deck2: Deck) -> Deck {
    return Deck(cards: deck1.cards + deck2.cards)
}