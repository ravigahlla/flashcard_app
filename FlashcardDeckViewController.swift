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
    var fcDeck: FlashcardDeck?
    
    @IBOutlet weak var flashcardView: UIView! // main view container for a flashcard
    
    private var fcFront: FlashcardFront?
    private var fcBack: FlashcardBack?
    
    private var isFront = true // variable to keep tabs on visible side of flashcard
    
    private var fcPanSideMargin = CGFloat(100.0) // the minimum length from side margins before we "swipe" to next card
    private var fcPanTopBottomMargin = CGFloat(30.0) // the minimum length from top and bottom margins before we "swipe" to the next card
    private var panBeginEndPoints = (beganInFC: Bool(), endedInFC: Bool()) // making class variable because values aren't set correctly if local within pan gesture method
    
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
        self.fcFront = FlashcardFront(frame: flashcardFaceRect)
        self.fcBack = FlashcardBack(frame: flashcardFaceRect)
        
        // debugging
        print("flashcard width = ", self.flashcardView.frame.width, "height = ", self.flashcardView.frame.height)
        print("fcFront width = ", self.fcFront?.frame.width, "height = ", self.fcFront?.frame.height)
        
        updateFlashcardData() // load the data from the deck
        
        self.flashcardView?.addSubview(fcFront!)
        self.flashcardView.addSubview(fcBack!)
        fcBack?.isHidden = true
        
        self.fcFront?.backgroundColor = UIColor.red
        
        /*
        for subview in self.flashcardView.subviews { // debugging
            print(subview.debugDescription)
        }*/
    }
    
    private func initFlashcardGestures() {
        
        self.view.isUserInteractionEnabled = true // for bringing back a flashcard
        fcFront?.isUserInteractionEnabled = true
        fcBack?.isUserInteractionEnabled = true
        
        // add tap gesture to the flashcard, to recognize when to flip to back
        let fcFrontTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        fcFront?.addGestureRecognizer(fcFrontTapGesture)
        
        let fcBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        fcBack?.addGestureRecognizer(fcBackTapGesture)
        
        // add pan gesture recognizers, for a more "Tinder"-like swipe functionality
        //let fcFrontPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //let fcBackPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //fcFront?.addGestureRecognizer(fcFrontPanGesture)
        //fcBack?.addGestureRecognizer(fcBackPanGesture)
        
        // add pan gesture recognizer to entire area, to help differentiate between removing current, and adding back previous flashcards
        let fcBringBackPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(fcBringBackPanGesture)
        
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
        
        fcFront?.addGestureRecognizer(fcFrontUpSwipeGesture)
        fcFront?.addGestureRecognizer(fcFrontDownSwipeGesture)
        fcFront?.addGestureRecognizer(fcFrontLeftSwipeGesture)
        fcFront?.addGestureRecognizer(fcFrontRightSwipeGesture)
        
        let fcBackUpSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackDownSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackLeftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackRightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        fcBackUpSwipeGesture.direction = UISwipeGestureRecognizerDirection.up
        fcBackDownSwipeGesture.direction = UISwipeGestureRecognizerDirection.down
        fcBackLeftSwipeGesture.direction = UISwipeGestureRecognizerDirection.left
        fcBackRightSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
        
        fcBack?.addGestureRecognizer(fcBackUpSwipeGesture)
        fcBack?.addGestureRecognizer(fcBackDownSwipeGesture)
        fcBack?.addGestureRecognizer(fcBackLeftSwipeGesture)
        fcBack?.addGestureRecognizer(fcBackRightSwipeGesture)
         */
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        os_log("handle tap gesture", log: OSLog.default, type: .debug)
        
        if isFront {
            print("tapped on front")
            
            // before you flip, hide the subviews
            self.fcFront?.isHidden = true
            self.fcBack?.isHidden = false
            
            // the bloody flip animation
            UIView.transition(from: self.fcFront!, to: self.fcBack!, duration: 0.3, options: .transitionFlipFromRight)
            
            // update what flashcard is facing front
            self.isFront = false

        } else {
            print("tapped on back")
            
            // before you flip, hide the subviews
            self.fcFront?.isHidden = false
            self.fcBack?.isHidden = true
            
            // the bloody flip animation
            UIView.transition(from: self.fcBack!, to: self.fcFront!, duration: 0.3, options: .transitionFlipFromRight)
            
            // update what flashcard is facing front
            self.isFront = true
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        let fcTranslation = sender.translation(in: self.view) // keep track of changing x,y coords
        
        if sender.state == UIGestureRecognizerState.began {
            /*
            // debugging
            print("began at ", sender.location(in: self.view), " in view")
            print("began at ", sender.location(in: self.fcFront), " in flashcardView")
            print("in fcFront? ", self.fcFront?.frame.contains(sender.location(in: self.fcFront)))
            */
            panBeginEndPoints.beganInFC = (self.fcFront?.frame.contains(sender.location(in: self.fcFront)))!
            //print(panBeginEndPoints.beganInFC)
        } // handle the dragging animation in here
        else if sender.state == UIGestureRecognizerState.changed {
            /*
            // debugging
            //print("you are still panning")
            print(panBeginEndPoints.beganInFC)
            if (panBeginEndPoints.beganInFC) {
                print("started in flashcard")
            }
            else {
                print ("started outside of flashcard")
            }
            */
            
            if (((self.fcFront?.frame.contains(sender.location(in: self.fcFront)))! || (self.fcBack?.frame.contains(sender.location(in: self.fcBack)))!) && panBeginEndPoints.beganInFC) {
                /*
                // debugging
                print("in flashcardView? ", self.flashcardView.frame.contains(sender.location(in: self.flashcardView)))
                print("in fcFront? ", self.fcFront?.frame.contains(sender.location(in: self.fcFront)))
                */
                self.flashcardView.center = CGPoint(x: self.flashcardView.center.x + fcTranslation.x, y: self.flashcardView.center.y + fcTranslation.y)
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
            
        } // all the swipe animation/logic here
        else if sender.state == UIGestureRecognizerState.ended {
            /*
            // debugging
            print("stopped at ", sender.location(in: self.view), " in view")
            print("stopped at ", sender.location(in: self.fcFront), " in flashcardView")
            print("in fcFront? ", self.fcFront?.frame.contains(sender.location(in: self.fcFront)))
            */
            panBeginEndPoints.endedInFC = (self.fcFront?.frame.contains(sender.location(in: self.fcFront)))!
            
            // if you swipe left...
            if self.flashcardView.center.x < self.fcPanSideMargin {
                os_log("you swiped left")
                    
                // animate the previous card off of the screen to the left, at some extreme x position
                UIView.animate(withDuration: 0.2, animations: {
                    self.flashcardView.center = CGPoint(x: self.flashcardView.center.x - self.view.frame.width*2, y: self.flashcardView.center.y)
                })
                    
            } // else you swipe right
            else if self.flashcardView.center.x > self.view.frame.width - self.fcPanSideMargin {
                os_log("you swiped right")
                    
                // animate the previous card off of the screen to the right, at some extreme x position
                UIView.animate(withDuration: 0.2, animations: {
                    self.flashcardView.center = CGPoint(x: self.flashcardView.center.x + self.view.frame.width*2, y: self.flashcardView.center.y)
                })
            } // else you swipe up
            else if self.flashcardView.center.y < CGFloat(self.fcPanTopBottomMargin) {
                os_log("you swiped up")
                    
                // animate the previous card off of the screen to the top, at some extreme y position
                UIView.animate(withDuration: 0.2, animations: {
                    self.flashcardView.center = CGPoint(x: self.flashcardView.center.x, y: self.flashcardView.center.y - self.view.frame.height*2)
                })
                    
            } // else you swipe down
            else if self.flashcardView.center.y > self.view.frame.height - CGFloat(self.fcPanTopBottomMargin) {
                os_log("you swiped down")
                    
                // animate the previous card off of the screen to the top, at some extreme y position
                UIView.animate(withDuration: 0.2, animations: {
                    self.flashcardView.center = CGPoint(x: self.flashcardView.center.x, y: self.flashcardView.center.y + self.view.frame.height*2)
                })
                    
                nextFlashCard()
                    
            } // ELSE just redraw the card to the center of the view
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.flashcardView.center = self.view.center
                    })
            }
        }
    }
    
    /*
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        os_log("handle swipe gesture", log: OSLog.default, type: .debug)
        
        var debug = "you swiped "
        
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirection.up:
                debug += "up on the "
                self.fcDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            case UISwipeGestureRecognizerDirection.down:
                debug += "down on the "
                self.fcDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            case UISwipeGestureRecognizerDirection.left:
                debug += "left on the "
                self.fcDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            case UISwipeGestureRecognizerDirection.right:
                debug += "right on the "
                self.fcDeck?.nextFC() // advance to the next card
                updateFlashcardData() // and update the flashcards
            
            default: print("unknown swipe!")
        }
        
        if self.isFront {
            debug += "front flashcard!"
        } else {
            debug += "back flashcard!"
        }
        
        print(debug)
    }*/
    
    func nextFlashCard() {
        // instantiate the next flashcard here
        self.fcDeck?.nextFC()
        // remove previous flashcard subviews
        // instantiate the next flashcard in the middle of the view
        updateFlashcardData()
        
        // if the flashcard deck is greater than 1
        // display the front-face of the next flashcard behind the current flashcard, drawn slightly above and to the right of the current flashcard (a negative coordinate, to make it look like there is a deck of cards
        // if the current flashcard has been removed
        //  advance to the next flashcard in the array of flashcards
        //  pop-off the previous two subviews (prev front and prev back)
        //  bring the previous flashcard front and center of main view
        //  instantiate the back of the flashcard with data, and add as a subview
        // if there are more flashcards left,
        //  then display the front face of the next flashcard behind the current flashcard, drawn slightly above and to the right of the current flashcard...
    }
    
    func updateFlashcardData() {
        
        self.fcFront?.titleLabel.text = self.fcDeck?.getFlashcardAt(position: (self.fcDeck?.currentPosition)!).getQuestion()
        
        self.fcBack?.answerTextView.text = self.fcDeck?.getFlashcardAt(position: (self.fcDeck?.currentPosition)!).getAnswer()
        
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
        
        self.fcDeck = FlashcardDeck(name: "Sample Deck", currentPosition: 0, deck: [fc1, fc2, fc3])
        
        os_log("loaded sample flashcards", log: OSLog.default, type: .debug)
    }
    
    func didPanForPrevFlashcard(begin: CGPoint, end: CGPoint) -> Bool {
        os_log("in didPanForPrevFlashcard", log: OSLog.default, type: .debug)
        
        var result: Bool
        
        // if you began panning from outside the flashcard, and ended inside the flashcard
        if !((self.fcFront?.frame.contains(begin))! || (self.fcBack?.frame.contains(begin))!) && ((self.fcFront?.frame.contains(end))! || (self.fcBack?.frame.contains(end))!) {
            result = true // you want to bring back the previous flashcard
        } else {
            result = false
        }
        
        return result
    }
    
    func didPanToNextFlashcard(begin: CGPoint, end: CGPoint) -> Bool {
        os_log("in didPanToNextFlashcard", log: OSLog.default, type: .debug)
        
        var result: Bool
        
        // if you began panning from inside the flashcard, and ended outside the flashcard
        if ((self.fcFront?.frame.contains(begin))! || (self.fcBack?.frame.contains(begin))!) && !((self.fcFront?.frame.contains(end))! || (self.fcBack?.frame.contains(end))!) {
            result = true // you want to go to the next flashcard
        } else {
            result = false
        }
        
        return result
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
            
            case "fcFrontSegue":
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
