//
//  FlashcardDeck.swift
//  Represent a deck of flashcards
//
//  Created by Ravi Gahlla on 5/22/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class FlashcardDeck {
    
    // MARK: Properties
    var name: String // name of the deck of cards
    var currentPosition: Int // position in deck
    var deck = [Flashcard]() // deck of flashcards
    
    // MARK: Initialization
    init(name: String, currentPosition: Int?, deck: [Flashcard]) {
        self.name = name
        
        if currentPosition == nil {
            self.currentPosition = 0
        } else {
            self.currentPosition = currentPosition!
        }
        
        self.deck = deck
    }
    
    func getFlashcardAt(position: Int) -> Flashcard {
        return deck[position]
    }
    
    func nextFC() {
        if self.currentPosition < self.deck.count - 1 {
            self.currentPosition += 1
        } else { // if you reach the last card, you can't go further (stay on last card)
            self.currentPosition = deck.count - 1
        }
    }
    
    func prevFC() {
        if self.currentPosition > 1 {
            self.currentPosition -= 1
        } else { // if you reach the first card, you can't go further (stay on first card)
            self.currentPosition = 0
        }
    }
}
