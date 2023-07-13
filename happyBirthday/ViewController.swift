//
//  ViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 10/07/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var friendsNameTextField: UITextField!
    @IBOutlet weak var friendsAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        friendsNameTextField.delegate = self
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextVC = segue.destination as? NextViewController else { return }
        
        let friendsName = friendsNameTextField.text ?? "FRIEND"
        let avatar = friendsAvatar.image ?? UIImage(named: "face35")
        
        let friend = BirthdayBoy(
            name: friendsName,
            image: avatar!,
            age: 18,
            wellWisher: "Anonymous"
        )
        nextVC.friend = friend
    }
    
    @IBAction func nextButtonHasPressed(_ sender: Any) {
        
    }
    
    
    
}

extension ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

