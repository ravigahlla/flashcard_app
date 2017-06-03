//
//  FlashcardFront.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/25/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

@IBDesignable class FlashcardFront: UIStackView, UITextFieldDelegate {
    
    // MARK: Properties
    private var titleLabel = UILabel()
    private var titleTextField = UITextField()
    
    let flashcardViewSpacing = 5.0

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.setupStackView()
        self.setupFlashcardFront()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupStackView()
        self.setupFlashcardFront()
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        self.titleTextField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        os_log("in textFieldDidEndEditing", log: OSLog.default, type: .debug)
        self.titleLabel.text = self.titleTextField.text
        //saveFlashcard()
    }
    
    // MARK: Private Methods
    private func setupStackView() {
        os_log("in setupStackView", log: OSLog.default, type: .debug)
        
        self.axis = UILayoutConstraintAxis.vertical // stack views vertically
        self.spacing = CGFloat(self.flashcardViewSpacing)
        print(self.superview?.frame ?? "(empty)")
        print("frame = ", self.frame)
        print("bounds = ", self.bounds)
        
        /*
        //self.widthAnchor.constraint(equalToConstant: margins.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        */
    }
    
    private func setupFlashcardFront() {
        os_log("in setupFrontFlashcard", log: OSLog.default, type: .debug)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.text = "(no question)"
        self.titleLabel.heightAnchor.constraint(equalToConstant: CGFloat(10.0))
        addArrangedSubview(titleLabel)
        
        //self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextField.isUserInteractionEnabled = true
        self.titleTextField.textAlignment = NSTextAlignment.center
        self.titleTextField.placeholder = "enter new title here"
        self.titleTextField.enablesReturnKeyAutomatically = true
        self.titleTextField.delegate = self
        addArrangedSubview(titleTextField)
    }
}
