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
    @IBOutlet weak var flashcardView: UIView! // main view container for a flashcard
    
    private var flashcardFront: FlashcardFront?
    private var flashcardBack: FlashcardBack?
    
    private var isFrontFlashcardFacing = true // variable to keep tabs on visible side of flashcard
    
    override func viewDidLoad() {
        os_log("in viewDidLoad", log: OSLog.default, type: .debug)
        
        super.viewDidLoad()
        
        initFlashcard()
        initFlashcardGestures()
    }
    
    // MARK: Force a landscape orientation of the flashcard view controller
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    // MARK: Private methods
    private func initFlashcard() {
        
        // store common superview dimensions
        let flashcardFaceRect = CGRect(x: 0.0, y: 0.0, width: self.flashcardView.frame.width, height: self.flashcardView.frame.height)
        
        // add the front flashcard in the subviews array
        self.flashcardFront = FlashcardFront(frame: flashcardFaceRect)
        self.flashcardView?.addSubview(flashcardFront!)
        
        // add the back flashcard in the subviews array, and hide it from the user
        self.flashcardBack = FlashcardBack(frame: flashcardFaceRect)
        self.flashcardView.addSubview(flashcardBack!)
        flashcardBack?.isHidden = true
        
        /*
        for subview in self.flashcardView.subviews { // debugging
            print(subview.debugDescription)
        }*/
    }
    
    private func initFlashcardGestures() {
        
        flashcardFront?.isUserInteractionEnabled = true
        flashcardBack?.isUserInteractionEnabled = true
        
        // add tap gesture to the flashcard, to recognize when to flip to back
        let fcFrontTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardFront?.addGestureRecognizer(fcFrontTapGesture)
        
        let fcBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardBack?.addGestureRecognizer(fcBackTapGesture)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        os_log("handle tap gesture", log: OSLog.default, type: .debug)
        
        if isFrontFlashcardFacing {
            print("tapped on front")
            
            // before you flip, hide the subviews
            self.flashcardFront?.isHidden = true
            self.flashcardBack?.isHidden = false
            
            // the bloody flip animation
            UIView.transition(from: self.flashcardFront!, to: self.flashcardBack!, duration: 0.3, options: .transitionFlipFromRight)
            
            // update what flashcard is facing front
            self.isFrontFlashcardFacing = false

        } else {
            print("tapped on back")
            
            // before you flip, hide the subviews
            self.flashcardFront?.isHidden = false
            self.flashcardBack?.isHidden = true
            
            // the bloody flip animation
            UIView.transition(from: self.flashcardBack!, to: self.flashcardFront!, duration: 0.3, options: .transitionFlipFromRight)
            
            // update what flashcard is facing front
            self.isFrontFlashcardFacing = true
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        os_log("in prepare", log: OSLog.default, type: .debug)
        
        super.prepare(for: segue, sender: sender)
        /*
         switch (segue.identifier ?? "") {
         
         }*/
    }
    
    /*
    var flashcards: FlashcardDeck?

    
    override func viewDidLoad() {
        os_log("in viewDidLoad", log: OSLog.default, type: .debug)
        
        super.viewDidLoad()
     
        // add tap gesture to the front uiview, to recognize when to flip to back
        let frontFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        flashcardFrontContainerView.addGestureRecognizer(frontFCTapGesture)
        
        // add tap gesture to the back uiview, to recognize when to flip to back
        let backFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        flashcardBackContainerView.addGestureRecognizer(backFCTapGesture)
        
        // add swipe gesture to the front uiview, to recognize when to go to the next card
        let frontFCSwipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleFrontFCRightSwipe))
        let frontFCSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleFrontFCLeftSwipe))
        frontFCSwipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
        frontFCSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        flashcardFrontContainerView.addGestureRecognizer(frontFCSwipeRightGesture)
        flashcardFrontContainerView.addGestureRecognizer(frontFCSwipeLeftGesture)
        
        // add swipe gesture to the back uiview, to recognize when to go to the next card
        let backFCSwipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackFCRightSwipe))
        let backFCSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackFCLeftSwipe))
        backFCSwipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
        backFCSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        flashcardBackContainerView.addGestureRecognizer(backFCSwipeRightGesture)
        flashcardBackContainerView.addGestureRecognizer(backFCSwipeLeftGesture)
        
        flashcardFrontContainerView.alpha = 1
        flashcardBackContainerView.alpha = 0
 
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
    
    
    func handleFrontFCRightSwipe() {
        os_log("swiped right on front", log: OSLog.default, type: .debug)
    }
    
    func handleFrontFCLeftSwipe() {
        os_log("swiped left on front", log: OSLog.default, type: .debug)
    }
    
    func handleBackFCRightSwipe() {
        os_log("swiped right on back", log: OSLog.default, type: .debug)
    }
    
    func handleBackFCLeftSwipe() {
        os_log("swiped left on back", log: OSLog.default, type: .debug)
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
                //self.addChildViewController(fcFrontViewController);
            
            case "flashcardBackSegue":
                os_log("entered flashcard back segue", log: OSLog.default, type: .debug)
                guard let fcBackViewController = segue.destination as? FlashcardBackViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                // pass current flashcard to the front controller
                fcBackViewController.flashcard = fcDeck?.deck[(fcDeck?.currentPosition)!]
                //self.addChildViewController(fcBackViewController)
        
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
 */
}
