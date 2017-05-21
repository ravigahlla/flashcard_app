//
//  FlashcardViewController.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/20/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class FlashcardViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var flashcardFrontContainerView: UIView!
    @IBOutlet weak var flashcardBackContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // add tap gesture to the front uiview, to recognize when to flip to back
        let frontFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardFrontContainerView.addGestureRecognizer(frontFCTapGesture)
        
        // add tap gesture to the back uiview, to recognize when to flip to back
        let backFCTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        flashcardBackContainerView.addGestureRecognizer(backFCTapGesture)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
