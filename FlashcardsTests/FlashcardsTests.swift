//
//  FlashcardsTests.swift
//  FlashcardsTests
//
//  Created by Ravi Gahlla on 5/14/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import XCTest
@testable import Flashcards

class FlashcardsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: FlashcardDeck Class Tests
    func testFlashcardsInitializationSucceeds() {
        // non-empty flashcard deck string
        // non-empty position
        // initialized flashcards
    }
    
    func testFlashcardsInitializationFails() {
        // non-empty flashcard deck
        // empty position
        // negative position
        // empty flashcards
    }
}
