//
//  Flashcard.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/15/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class Flashcard {
    // MARK: Properties
    var fcQuestion: String
    var fcAnswer: String
    
    init?(question: String, answer: String) {
        guard !question.isEmpty || !answer.isEmpty else {
            return nil
        }
        
        self.fcQuestion = question
        self.fcAnswer = answer
    }
}
