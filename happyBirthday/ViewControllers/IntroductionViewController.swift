//
//  IntroductionViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 12/08/2023.
//

import UIKit

class IntroductionViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = juicyColores.randomElement()
        textView.text = introduction
    }
    
    @IBAction func nextAction(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
