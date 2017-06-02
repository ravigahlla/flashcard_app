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
        
        /*
        self.axis = UILayoutConstraintAxis.vertical // stack views vertically
        self.distribution = UIStackViewDistribution.fill
        self.alignment = UIStackViewAlignment.center
        self.spacing = CGFloat(self.flashcardViewSpacing)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        */
        print(self.superview?.frame ?? "(empty)")
        print("frame = ", self.frame)
        print("bounds = ", self.bounds)
        
        /*
        let margins = self.layoutMarginsGuide
         
        self.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: margins.heightAnchor).isActive = true
        */
        // center this view
        //self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: self.frame.width / 2.0))
        
        // max out the width of this UIStackView
        /*
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: self.bounds.width))
        
        // max out the height of this UIStackView
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: self.bounds.height))
         */
    }
    
    private func setupFlashcardFront() {
        os_log("in setupFrontFlashcard", log: OSLog.default, type: .debug)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.text = "(no question)"
        /*
        self.titleLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
         */
        addArrangedSubview(titleLabel)
        
        /*
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextField.textAlignment = NSTextAlignment.center
        self.titleTextField.borderStyle = UITextBorderStyle.bezel
        self.titleTextField.placeholder = "enter new title here"
        self.titleTextField.enablesReturnKeyAutomatically = true
        self.titleTextField.delegate = self
        addArrangedSubview(titleTextField)
        */
    }
}
