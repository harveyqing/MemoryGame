//
//  Card.swift
//  MemoryGame
//
//  Created by qingtian on 16/2/27.
//  Copyright © 2016年 qingtian. All rights reserved.
//

import UIKit

enum Suit: CustomStringConvertible {
    case Spades, Hearts, Diamonds, Clubs
    
    var description: String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

enum Rank: Int, CustomStringConvertible {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    var description: String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queue"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

struct Card: CustomStringConvertible, Equatable {
    private let rank: Rank
    private let suit: Suit
    
    var description: String {
        return "\(rank.description)_of_\(suit.description)"
    }
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
}

func == (card1: Card, card2: Card) -> Bool {
    return card1.rank == card2.rank && card1.suit == card2.suit
}
