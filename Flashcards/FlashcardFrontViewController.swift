//
//  FlashcardFrontViewController.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/14/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class FlashcardFrontViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var fcQuestionLabel: UILabel!
    @IBOutlet weak var fcQuestionTextField: UITextField!
    
    var flashcard = Flashcard()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load any meals
        if let savedFlashcard = loadFlashcard() {
            flashcard = savedFlashcard
            os_log("after loaded flashcard", log: OSLog.default, type: .debug)
            fcQuestionLabel.text = flashcard.fcQuestion
        } else {
            flashcard = Flashcard()
            fcQuestionLabel.text = flashcard.defaultQ
        }
        
        fcQuestionTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        flashcard.fcQuestion = textField.text!
        fcQuestionLabel.text = flashcard.fcQuestion
        
        saveFlashcard()
    }
    
    // MARK: Private methods
    private func saveFlashcard() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(flashcard, toFile: Flashcard.ArchiveURL.path)

        if isSuccessfulSave {
            os_log("Flashcard successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save flashcard...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadFlashcard() -> Flashcard? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Flashcard.ArchiveURL.path) as? Flashcard
    }

}

