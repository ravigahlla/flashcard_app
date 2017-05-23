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

    var fcDeck: FlashcardDeck? // optional - either you load a deck, or you have to create one
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the deck with a sample for now
        loadSampleFlashcards()

        // add tap gesture to the front uiview, to recognize when to flip to back
        let frontFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardFrontContainerView.addGestureRecognizer(frontFCTapGesture)
        
        // add tap gesture to the back uiview, to recognize when to flip to back
        let backFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardBackContainerView.addGestureRecognizer(backFCTapGesture)
    }
    
    func loadSampleFlashcards() {
        
        guard let fc1 = Flashcard(fcQuestion: "What is 2+2?", fcAnswer: "4") else {
            fatalError("Unable to instantiate fc1")
        }
        
        guard let fc2 = Flashcard(fcQuestion: "How do you say \"dream\" in Spanish?", fcAnswer: "Sueño") else {
            fatalError("Unable to instantiate fc2")
        }
        
        var sampleDeck = [Flashcard]()
        
        sampleDeck += [fc1, fc2]
        
        fcDeck = FlashcardDeck(name: "Sample Deck", currentPosition: 0, deck: sampleDeck)
        os_log("loaded sample flashcards", log: OSLog.default, type: .debug)
    }
    
    func handleTap() {
        os_log("tapped on", log: OSLog.default, type: .debug)
        
        // flip the view on whatever is being displayed
        if flashcardFrontContainerView.alpha == 1 {
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
            flashcardFrontContainerView.alpha = 0
            flashcardBackContainerView.alpha = 1

            os_log("flipped front to back", log: OSLog.default, type: .debug)
        } else {
            /*
            UIView.transition(from: self.flashcardBackContainerView, to: self.flashcardFrontContainerView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            */
            flashcardFrontContainerView.alpha = 1
            flashcardBackContainerView.alpha = 0
            /*
            UIView.animate(withDuration: 0.5, animations: {
                self.flashcardFrontContainerView.alpha = 1
                self.flashcardBackContainerView.alpha = 0
            })*/
            os_log("flipped back to front", log: OSLog.default, type: .debug)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "flashcardFrontSegue":
                guard let fcFrontViewController = segue.destination as? FlashcardFrontViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                // pass current flashcard to the front controller
                //fcFrontViewController.flashcard = Flashcard(fcQuestion: "Ravi", fcAnswer: "Singh")
                print(fcDeck?.deck[0].fcQuestion)
                fcFrontViewController.flashcard = fcDeck?.deck[0]
                //fcFrontViewController.flashcard = (fcDeck?.getFlashcardAt(position: (fcDeck?.currentPosition)!))!
            
            case "flashcardBackSegue":
                guard let fcBackViewController = segue.destination as? FlashcardBackViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                fcBackViewController.flashcard = Flashcard(fcQuestion: "Ravi", fcAnswer: "Singh")
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
}
