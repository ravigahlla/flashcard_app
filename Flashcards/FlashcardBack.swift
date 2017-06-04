//
//  FlashcardBack.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/29/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

@IBDesignable class FlashcardBack: UIStackView, UITextViewDelegate {
    
    // MARK: Properties
    var answerTextView = UITextView()
    var answerSaveButton = UIButton(type: UIButtonType.system)

    let flashcardViewSpacing = 5.0
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupStackView()
        self.setupFlashcardBack()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupStackView()
        self.setupFlashcardBack()
    }
    
    // MARK: Private Methods
    private func setupStackView() {
        os_log("in setupStackView", log: OSLog.default, type: .debug)
        
        self.axis = UILayoutConstraintAxis.vertical // stack views vertically
        self.distribution = UIStackViewDistribution.fill
        self.alignment = UIStackViewAlignment.center
        self.spacing = CGFloat(self.flashcardViewSpacing)
    }
    
    private func setupFlashcardBack() {
        os_log("in setupBackFlashcard", log: OSLog.default, type: .debug)
        
        self.answerTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.answerTextView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        self.answerTextView.delegate = self
        
        self.answerTextView.isUserInteractionEnabled = true
        self.answerTextView.isEditable = true
        self.answerTextView.backgroundColor = UIColor.yellow
        self.answerTextView.isSelectable = true
        self.answerTextView.isScrollEnabled = false // problem with rendering if set to true: UIStackView needs a definitive size
        self.answerTextView.text = "this is a sample answer"
        addArrangedSubview(self.answerTextView)
        
        self.answerSaveButton.translatesAutoresizingMaskIntoConstraints = false
        self.answerSaveButton.isUserInteractionEnabled = true
        self.answerSaveButton.isEnabled = true
        self.answerSaveButton.setTitle("Save", for: UIControlState.normal)
        self.answerSaveButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.answerSaveButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        addArrangedSubview(self.answerSaveButton)
    }

}
