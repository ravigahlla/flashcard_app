//
//  Flashcard.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/15/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class Flashcard: NSObject, NSCoding {
    
    // MARK: Properties
    var defaultQ = String("(no question)")
    var defaultA = String("(no answer)")
    
    var fcQuestion: String
    var fcAnswer: String
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("flashcards")
    
    //MARK: Types
    struct PropertyKey {
        static let fcQuestion = "fcQuestion"
        static let fcAnswer = "fcAnswer"
    }
    
    // MARK: Initialization
    override init() {
        self.fcQuestion = defaultQ!
        self.fcAnswer = defaultA!
        
        super.init()
    }
    
    init?(fcQuestion: String, fcAnswer: String) {
        self.fcQuestion = fcQuestion
        self.fcAnswer = fcAnswer
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fcQuestion, forKey: PropertyKey.fcQuestion)
        aCoder.encode(fcAnswer, forKey: PropertyKey.fcAnswer)
    }
    
    //
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let fcQuestion = aDecoder.decodeObject(forKey: PropertyKey.fcQuestion) as? String else {
            os_log("Unable to decode the name for a Flashcard object.", log: OSLog.default, type: .debug)
            return nil
        }
        let fcAnswer = aDecoder.decodeObject(forKey: PropertyKey.fcAnswer) as? String
        
        // Must call designated initializer.
        self.init(fcQuestion: fcQuestion, fcAnswer: fcAnswer!)
    }
}
