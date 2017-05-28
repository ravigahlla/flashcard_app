//
//  FlashcardFront.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/25/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

@IBDesignable class FlashcardFront: UIStackView {

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

    // MARK: Private Methods
    private func setupStackView() {
        os_log("in setupStackView", log: OSLog.default, type: .debug)
        
        //self.axis = UILayoutConstraintAxis.vertical
        /*self.distribution = UIStackViewDistribution.fillEqually
        self.alignment = UIStackViewAlignment.fill
        self.spacing = 5*/
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlashcardFront() {
        os_log("in setupFrontFlashcard", log: OSLog.default, type: .debug)
 
        
        let questionLabel = UILabel(frame: CGRect(x: center.x, y: center.y, width: 100/*self.frame.width*/, height: 100/*self.frame.height*/))
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
 
        questionLabel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        questionLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive =  true
 
        questionLabel.layer.borderColor = UIColor.black.cgColor
        questionLabel.layer.borderWidth = 1.0
        questionLabel.textAlignment = NSTextAlignment.center
        questionLabel.text = "Sample Flashcard"
        
        self.addArrangedSubview(questionLabel)
 
        /*
        let questionTextField = UITextField(frame: CGRect(x: center.x, y: center.y, width: 100, height: 100))
        questionTextField.translatesAutoresizingMaskIntoConstraints = false
        questionTextField.textAlignment = NSTextAlignment.center
        questionTextField.placeholder = "enter new question here..."
        
        self.addArrangedSubview(questionTextField)
        */
    }
}
