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
    var flashcardDeck: FlashcardDeck?
    
    @IBOutlet weak var flashcardView: UIView! // main view container for a flashcard
    
    private var flashcardFront: FlashcardFront?
    private var flashcardBack: FlashcardBack?
    
    private var isFrontFlashcardFacing = true // variable to keep tabs on visible side of flashcard
    private var fcSwipeSideMargin = 100.0 // the minimum length from side margins before we "swipe" to next card
    private var fcSwipeTopBottomMargin = 30.0 // the minimum length from top and bottom margins before we "swipe" to the next card
    
    override func viewDidLoad() {
        os_log("in viewDidLoad", log: OSLog.default, type: .debug)
        
        super.viewDidLoad()
        
        // draw a black border around the flashcard
        self.flashcardView.layer.borderWidth = 1.0
        self.flashcardView.layer.borderColor = UIColor.black.cgColor
        
        // load sample data
        loadSampleFlashcardDeck()
        
        // initialize the flashcard
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
        self.flashcardBack = FlashcardBack(frame: flashcardFaceRect)
        
        updateFlashcardData() // load the data from the deck
        
        self.flashcardView?.addSubview(flashcardFront!)
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
        
        // add pan gesture recognizers, for a more "Tinder"-like swipe functionality
        let fcFrontPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let fcBackPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        flashcardFront?.addGestureRecognizer(fcFrontPanGesture)
        flashcardBack?.addGestureRecognizer(fcBackPanGesture)
        
        /*
        // add directional swipe gestures to the flashcard, to recognize when to traverse to the next card
        let fcFrontUpSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let fcFrontDownSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let fcFrontLeftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        let fcFrontRightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        fcFrontUpSwipeGesture.direction = UISwipeGestureRecognizerDirection.up
        fcFrontDownSwipeGesture.direction = UISwipeGestureRecognizerDirection.down
        fcFrontLeftSwipeGesture.direction = UISwipeGestureRecognizerDirection.left
        fcFrontRightSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
        
        flashcardFront?.addGestureRecognizer(fcFrontUpSwipeGesture)
        flashcardFront?.addGestureRecognizer(fcFrontDownSwipeGesture)
        flashcardFront?.addGestureRecognizer(fcFrontLeftSwipeGesture)
        flashcardFront?.addGestureRecognizer(fcFrontRightSwipeGesture)
        
        let fcBackUpSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackDownSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackLeftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackRightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        fcBackUpSwipeGesture.direction = UISwipeGestureRecognizerDirection.up
        fcBackDownSwipeGesture.direction = UISwipeGestureRecognizerDirection.down
        fcBackLeftSwipeGesture.direction = UISwipeGestureRecognizerDirection.left
        fcBackRightSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
        
        flashcardBack?.addGestureRecognizer(fcBackUpSwipeGesture)
        flashcardBack?.addGestureRecognizer(fcBackDownSwipeGesture)
        flashcardBack?.addGestureRecognizer(fcBackLeftSwipeGesture)
        flashcardBack?.addGestureRecognizer(fcBackRightSwipeGesture)
         */
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
    
    func handlePan(sender: UIPanGestureRecognizer) {
        //os_log("you're panning the flashcard", log: OSLog.default, type: .debug) // prints too much when panning
        
        let fcTranslation = sender.translation(in: self.view)
        self.flashcardView.center = CGPoint(x: self.flashcardView.center.x + fcTranslation.x, y: self.flashcardView.center.y + fcTranslation.y)
        sender.setTranslation(CGPoint.zero, in: self.flashcardView)
        
        // debugging
        /*
        if sender.state == UIGestureRecognizerState.changed {
            print("new x = ", fcTranslation.x)
            print("new y = ", fcTranslation.y)
        }*/
        
        if sender.state == UIGestureRecognizerState.ended {
            
            // go to next card if your swipe ends outside swipe margins
            if self.flashcardView.center.x < CGFloat(self.fcSwipeSideMargin) || self.flashcardView.center.x > self.view.frame.width - CGFloat(self.fcSwipeSideMargin) || self.flashcardView.center.y < CGFloat(self.fcSwipeTopBottomMargin) || self.flashcardView.center.y > self.view.frame.height - CGFloat(self.fcSwipeTopBottomMargin) {
                os_log("next card!")
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.flashcardView.center = self.view.center
            })
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        os_log("handle swipe gesture", log: OSLog.default, type: .debug)
        
        var debug = "you swiped "
        
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirection.up:
                debug += "up on the "
                self.flashcardDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            case UISwipeGestureRecognizerDirection.down:
                debug += "down on the "
                self.flashcardDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            case UISwipeGestureRecognizerDirection.left:
                debug += "left on the "
                self.flashcardDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            case UISwipeGestureRecognizerDirection.right:
                debug += "right on the "
                self.flashcardDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            
            default: print("unknown swipe!")
        }
        
        if self.isFrontFlashcardFacing {
            debug += "front flashcard!"
        } else {
            debug += "back flashcard!"
        }
        
        print(debug)
    }
    
    func updateFlashcardData() {
        
        self.flashcardFront?.titleLabel.text = self.flashcardDeck?.getFlashcardAt(position: (self.flashcardDeck?.currentPosition)!).getQuestion()
        
        self.flashcardBack?.answerTextView.text = self.flashcardDeck?.getFlashcardAt(position: (self.flashcardDeck?.currentPosition)!).getAnswer()
        
    }
    
    // MARK: Sample data
    private func loadSampleFlashcardDeck() {
        
        guard let fc1 = Flashcard(q: "What is 2+2?", a: "4") as? Flashcard else {
            fatalError("Unable to instantiate fc1")
        }
        
        guard let fc2 = Flashcard(q: "How do you say \"dream\" in Spanish?", a: "Sueño") as? Flashcard else {
            fatalError("Unable to instantiate fc2")
        }
        
        guard let fc3 = Flashcard(q: "Tell me about a time when you held your ground as a Product Manager", a: "- Gift with Purchase MVP\n- Free-Shipping Threshold\n- Free-Shipping Banner") as? Flashcard else {
            fatalError("Unable to instantiate fc3")
        }
        
        self.flashcardDeck = FlashcardDeck(name: "Sample Deck", currentPosition: 0, deck: [fc1, fc2, fc3])
        
        os_log("loaded sample flashcards", log: OSLog.default, type: .debug)
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
