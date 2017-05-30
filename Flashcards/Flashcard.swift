//
//  Flashcard.swift
//  Represent a flashcard
//
//  Created by Ravi Gahlla on 5/15/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class Flashcard: NSObject, NSCoding {
    
    // MARK: Properties
    private var question: String
    private var answer: String
    
    // MARK: Types
    struct PropertyKey {
        static let question = "question"
        static let answer = "answer"
    }
    
    // MARK: Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("flashcards")
    
    // MARK: Initialization
    override init() {
        self.question = ""
        self.answer = ""
        
        super.init()
    }
    
    init(q: String, a: String) {
        self.question = q
        self.answer = a
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let question = aDecoder.decodeObject(forKey: PropertyKey.question) as? String else {
            os_log("Unable to decode the question for Flashcard object.", log: OSLog.default, type: .debug)
            return nil
        }
        let answer = aDecoder.decodeObject(forKey: PropertyKey.answer) as? String
        
        // Must call designated initializer.
        self.init(q: question, a: answer!)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(question, forKey: PropertyKey.question)
        aCoder.encode(answer, forKey: PropertyKey.answer)
    }
    
    // MARK: Methods
    func getQuestion() -> String {
        return self.question
    }
    
    func setQuestion(q: String) {
        self.question = q
    }
    
    func getAnswer() -> String {
        return self.answer
    }
    
    func setAnswer(a: String) {
        self.answer = a
    }
}
