//
//  FlashcardDeckViewController.swift
//  View/Edit a deck of flashcards
//
//  Created by Ravi Gahlla on 5/20/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class FlashcardDeckViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var flashcardFrontContainerView: UIView!
    @IBOutlet weak var flashcardBackContainerView: UIView!

    var fcDeck: FlashcardDeck?
    
    override func viewDidLoad() {
        os_log("viewDidLoad", log: OSLog.default, type: .debug)
        super.viewDidLoad()
        
        // initialize the deck with a sample for now
        //loadSampleFlashcards()

        // add tap gesture to the front uiview, to recognize when to flip to back
        let frontFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardFrontContainerView.addGestureRecognizer(frontFCTapGesture)
        
        // add swipe gesture to the front uiview, to recognize when to go to the next card
        let frontFCSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleFrontFCRightSwipe))
        frontFCSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
        flashcardFrontContainerView.addGestureRecognizer(frontFCSwipeGesture)
        
        // add tap gesture to the back uiview, to recognize when to flip to back
        let backFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardBackContainerView.addGestureRecognizer(backFCTapGesture)
        
        // add swipe gesture to the back uiview, to recognize when to go to the next card
        let backFCSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackFCRightSwipe))
        backFCSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
        flashcardBackContainerView.addGestureRecognizer(backFCSwipeGesture)
    }
    
    private func loadSampleFlashcards() {
        
        guard let fc1 = Flashcard(fcQuestion: "What is 2+2?", fcAnswer: "4") else {
            fatalError("Unable to instantiate fc1")
        }
        
        guard let fc2 = Flashcard(fcQuestion: "How do you say \"dream\" in Spanish?", fcAnswer: "Sueño") else {
            fatalError("Unable to instantiate fc2")
        }
        
        fcDeck = FlashcardDeck(name: "Sample Deck", currentPosition: 0, deck: [fc1, fc2])
        
        os_log("loaded sample flashcards", log: OSLog.default, type: .debug)
    }
    
    func handleTap() {
        os_log("tapped on", log: OSLog.default, type: .debug)
        
        // flip the view on whatever is being displayed
        if flashcardFrontContainerView.alpha == 0 {
            /*
            UIView.transition(from: self.flashcardFrontContainerView, to: self.flashcardBackContainerView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            
            flashcardFrontContainerView.alpha = 0
            flashcardBackContainerView.alpha = 1
            */
            /*
            UIView.animate(withDuration: 0.5, animations: {
                self.flashcardFrontContainerView.alpha = 0
                self.flashcardBackContainerView.alpha = 1
            })*/
            
            // flip the cards
            flashcardFrontContainerView.alpha = 1
            flashcardBackContainerView.alpha = 0

            os_log("flipped front to back", log: OSLog.default, type: .debug)
        } else {
            /*
            UIView.transition(from: self.flashcardBackContainerView, to: self.flashcardFrontContainerView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            */
            
            // flip the cards
            flashcardFrontContainerView.alpha = 0
            flashcardBackContainerView.alpha = 1
            /*
            UIView.animate(withDuration: 0.5, animations: {
                self.flashcardFrontContainerView.alpha = 1
                self.flashcardBackContainerView.alpha = 0
            })*/
            os_log("flipped back to front", log: OSLog.default, type: .debug)
        }
    }
    
    func handleFrontFCRightSwipe() {
        os_log("swiped right on front", log: OSLog.default, type: .debug)
    }
    
    func handleBackFCRightSwipe() {
        os_log("swiped right on back", log: OSLog.default, type: .debug)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        os_log("in prepare", log: OSLog.default, type: .debug)
        
        if fcDeck === nil { // don't load unnecessarily
            loadSampleFlashcards() // load sample flashcards in prepare because it is loaded before viewDidLoad(), causing a nil problem when trying to pass flashcard data to container views
        }
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
            case "flashcardFrontSegue":
                os_log("entered flashcard front segue", log: OSLog.default, type: .debug)
            
                guard let fcFrontViewController = segue.destination as? FlashcardFrontViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                // pass current flashcard to the front controller
                fcFrontViewController.flashcard = fcDeck?.deck[(fcDeck?.currentPosition)!]
            
            case "flashcardBackSegue":
                os_log("entered flashcard back segue", log: OSLog.default, type: .debug)
                guard let fcBackViewController = segue.destination as? FlashcardBackViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                // pass current flashcard to the front controller
                fcBackViewController.flashcard = fcDeck?.deck[(fcDeck?.currentPosition)!]
        
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
}
