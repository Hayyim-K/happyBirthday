//
//  MenuViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 13/08/2023.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        UISelectionFeedbackGenerator().selectionChanged()
        super.viewDidLoad()
        greetingsLabel.text = greetings
    }
    
    @IBAction func introductionButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @IBAction func aboutUsButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    
    @IBAction func start(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
}
