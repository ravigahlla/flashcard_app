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
    
    private var currentFlashcard = (front: FlashcardFront(), back: FlashcardBack())
    
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
        
        // load sample data before initializing the flashcards
        loadSampleFlashcardDeck()
        
        // initialize the flashcard
        initFlashcard()
        initFlashcardGestures()
        
        // force a landscape orientation
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
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
        
        // add the front flashcard in the subviews array
        self.flashcardView?.addSubview(self.currentFlashcard.front)
        self.flashcardView?.addSubview(self.currentFlashcard.back)
        
        self.flashcardView.clipsToBounds = true
        
        self.currentFlashcard.front.translatesAutoresizingMaskIntoConstraints = false
        self.currentFlashcard.back.translatesAutoresizingMaskIntoConstraints = false
        
        // inherit the constraints of the flashcardview
        self.currentFlashcard.front.topAnchor.constraint(equalTo: flashcardView.topAnchor).isActive = true
        self.currentFlashcard.back.topAnchor.constraint(equalTo: flashcardView.topAnchor).isActive = true
        
        self.currentFlashcard.front.bottomAnchor.constraint(equalTo: flashcardView.bottomAnchor).isActive = true
        self.currentFlashcard.back.bottomAnchor.constraint(equalTo: flashcardView.bottomAnchor).isActive = true
        
        self.currentFlashcard.front.leftAnchor.constraint(equalTo: flashcardView.leftAnchor).isActive = true
        self.currentFlashcard.back.leftAnchor.constraint(equalTo: flashcardView.leftAnchor).isActive = true
        
        self.currentFlashcard.front.rightAnchor.constraint(equalTo: flashcardView.rightAnchor).isActive = true
        self.currentFlashcard.back.rightAnchor.constraint(equalTo: flashcardView.rightAnchor).isActive = true
        
        self.currentFlashcard.front.heightAnchor.constraint(equalTo: flashcardView.heightAnchor).isActive = true
        self.currentFlashcard.back.widthAnchor.constraint(equalTo: flashcardView.widthAnchor).isActive = true
        
        self.currentFlashcard.back.heightAnchor.constraint(equalTo: flashcardView.heightAnchor).isActive = true
        self.currentFlashcard.back.widthAnchor.constraint(equalTo: flashcardView.widthAnchor).isActive = true
        
        self.currentFlashcard.back.isHidden = true
        
        // debugging
        /*
        print("flashcard width = ", self.flashcardView.frame.width, "height = ", self.flashcardView.frame.height)
        print("self.currentFlashcard.front width = ", self.currentFlashcard.front.frame.width, "height = ", self.currentFlashcard.front.frame.height)
        */
        updateFlashcardData() // load the data from the deck
        
        /*
        for subview in self.flashcardView.subviews { // debugging
            print(subview.debugDescription)
        }*/
    }
    
    private func initFlashcardGestures() {
        
        self.view.isUserInteractionEnabled = true // for bringing back a flashcard
        self.currentFlashcard.front.isUserInteractionEnabled = true
        self.currentFlashcard.back.isUserInteractionEnabled = true
        
        // add tap gesture to the flashcard, to recognize when to flip to back
        let fcFrontTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.currentFlashcard.front.addGestureRecognizer(fcFrontTapGesture)
        
        let fcBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.currentFlashcard.back.addGestureRecognizer(fcBackTapGesture)
        
        // add pan gesture recognizers, for a more "Tinder"-like swipe functionality
        //let fcFrontPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //let fcBackPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //self.currentFlashcard.front.addGestureRecognizer(fcFrontPanGesture)
        //self.currentFlashcard.back.addGestureRecognizer(fcBackPanGesture)
        
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
        
        self.currentFlashcard.front.addGestureRecognizer(fcFrontUpSwipeGesture)
        self.currentFlashcard.front.addGestureRecognizer(fcFrontDownSwipeGesture)
        self.currentFlashcard.front.addGestureRecognizer(fcFrontLeftSwipeGesture)
        self.currentFlashcard.front.addGestureRecognizer(fcFrontRightSwipeGesture)
        
        let fcBackUpSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackDownSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackLeftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        let fcBackRightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        fcBackUpSwipeGesture.direction = UISwipeGestureRecognizerDirection.up
        fcBackDownSwipeGesture.direction = UISwipeGestureRecognizerDirection.down
        fcBackLeftSwipeGesture.direction = UISwipeGestureRecognizerDirection.left
        fcBackRightSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
        
        self.currentFlashcard.back.addGestureRecognizer(fcBackUpSwipeGesture)
        self.currentFlashcard.back.addGestureRecognizer(fcBackDownSwipeGesture)
        self.currentFlashcard.back.addGestureRecognizer(fcBackLeftSwipeGesture)
        self.currentFlashcard.back.addGestureRecognizer(fcBackRightSwipeGesture)
         */
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        os_log("handle tap gesture", log: OSLog.default, type: .debug)
        
        if isFront {
            print("tapped on front")
            
            // the bloody flip animation
            UIView.transition(from: self.currentFlashcard.front, to: self.currentFlashcard.back, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromRight])
            
            // update what flashcard is facing front
            self.isFront = false

        } else {
            print("tapped on back")
            
            // the bloody flip animation
            UIView.transition(from: self.currentFlashcard.back, to: self.currentFlashcard.front, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromRight])
            
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
            print("began at ", sender.location(in: self.currentFlashcard.front), " in flashcardView")
            print("in self.currentFlashcard.front? ", self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))
            */
            if (self.isFront) {
                panBeginEndPoints.beganInFC = (self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))
            } else {
                panBeginEndPoints.beganInFC = (self.currentFlashcard.back.frame.contains(sender.location(in: self.currentFlashcard.back)))
            }
            
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
            
            if (self.isFront) {
                if (((self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))) && panBeginEndPoints.beganInFC) {
                    /*
                     // debugging
                     print("in flashcardView? ", self.flashcardView.frame.contains(sender.location(in: self.flashcardView)))
                     print("in self.currentFlashcard.front ", self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))
                     */
                    self.flashcardView.center = CGPoint(x: self.flashcardView.center.x + fcTranslation.x, y: self.flashcardView.center.y + fcTranslation.y)
                    sender.setTranslation(CGPoint.zero, in: self.view)
                }
            } else {
                if (((self.currentFlashcard.back.frame.contains(sender.location(in: self.currentFlashcard.back)))) && panBeginEndPoints.beganInFC) {
                    /*
                     // debugging
                     print("in flashcardView? ", self.flashcardView.frame.contains(sender.location(in: self.flashcardView)))
                     print("in self.currentFlashcard.front? ", self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))
                     */
                    self.flashcardView.center = CGPoint(x: self.flashcardView.center.x + fcTranslation.x, y: self.flashcardView.center.y + fcTranslation.y)
                    sender.setTranslation(CGPoint.zero, in: self.view)
                }
            }
            
        } // all the swipe animation/logic here
        else if sender.state == UIGestureRecognizerState.ended {
            /*
            // debugging
            print("stopped at ", sender.location(in: self.view), " in view")
            print("stopped at ", sender.location(in: self.currentFlashcard.front), " in flashcardView")
            print("in self.currentFlashcard.front? ", self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))
            */
            if (self.isFront) {
                panBeginEndPoints.endedInFC = (self.currentFlashcard.front.frame.contains(sender.location(in: self.currentFlashcard.front)))
            } else {
                panBeginEndPoints.endedInFC = (self.currentFlashcard.back.frame.contains(sender.location(in: self.currentFlashcard.back)))
            }
            
            // if you want to move on to the next card
            if panBeginEndPoints.beganInFC
            { // you want to take the current card out
                // if you swipe left...
                if self.flashcardView.center.x < self.fcPanSideMargin {
                    os_log("you swiped left")
                    
                    // animate the previous card off of the screen to the left, at some extreme x position
                    UIView.animate(withDuration: 0.2, animations: {
                        self.flashcardView.center = CGPoint(x: self.flashcardView.center.x - self.view.frame.width*2, y: self.flashcardView.center.y)
                    })
                    
                    nextFlashCard()
                    
                } // else you swipe right
                else if self.flashcardView.center.x > self.view.frame.width - self.fcPanSideMargin {
                    os_log("you swiped right")
                    
                    // animate the previous card off of the screen to the right, at some extreme x position
                    UIView.animate(withDuration: 0.2, animations: {
                        self.flashcardView.center = CGPoint(x: self.flashcardView.center.x + self.view.frame.width*2, y: self.flashcardView.center.y)
                    })
                    
                    nextFlashCard()
                    
                } // else you swipe up
                else if self.flashcardView.center.y < CGFloat(self.fcPanTopBottomMargin) {
                    os_log("you swiped up")
                    
                    // animate the previous card off of the screen to the top, at some extreme y position
                    UIView.animate(withDuration: 0.2, animations: {
                        self.flashcardView.center = CGPoint(x: self.flashcardView.center.x, y: self.flashcardView.center.y - self.view.frame.height*2)
                    })
                    
                    nextFlashCard()
                    
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
            } else if !panBeginEndPoints.beganInFC /*&& panBeginEndPoints.endedInFC*/ { // you want to bring the previous card back into the deck
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
        
        self.currentFlashcard.front.titleLabel.text = self.fcDeck?.getFlashcardAt(position: (self.fcDeck?.currentPosition)!).getQuestion()
        
        self.currentFlashcard.back.answerTextView.text = self.fcDeck?.getFlashcardAt(position: (self.fcDeck?.currentPosition)!).getAnswer()
        
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
        if !((self.currentFlashcard.front.frame.contains(begin)) || (self.currentFlashcard.back.frame.contains(begin))) && ((self.currentFlashcard.front.frame.contains(end)) || (self.currentFlashcard.back.frame.contains(end))) {
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
        if ((self.currentFlashcard.front.frame.contains(begin)) || (self.currentFlashcard.back.frame.contains(begin))) && !((self.currentFlashcard.front.frame.contains(end)) || (self.currentFlashcard.back.frame.contains(end))) {
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
