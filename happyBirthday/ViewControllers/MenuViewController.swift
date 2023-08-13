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
        super.viewDidLoad()
        greetingsLabel.text = greetings
    }
    
}
