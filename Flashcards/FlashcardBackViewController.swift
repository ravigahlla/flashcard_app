//
//  FlashcardBackViewController.swift
//  Flashcards
//
//  Created by Ravi Gahlla on 5/14/17.
//  Copyright © 2017 Ravi Gahlla. All rights reserved.
//

import UIKit
import os.log

class FlashcardBackViewController: UIViewController, UITextViewDelegate {
    // MARK: Properties
    @IBOutlet weak var flashcardAnswerTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        flashcardAnswerTextView.delegate = self
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

    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
