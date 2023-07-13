//
//  NextViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 11/07/2023.
//

// add keyboard handler for hidding a kayboard
//

import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var yearsQuestionLabel: UILabel!
    @IBOutlet weak var friendsAgeLabel: UILabel!
    @IBOutlet weak var yearsPickerView: UIPickerView!
    @IBOutlet weak var playerNameTextField: UITextField!
    
    private var friendsAge = 0
    
    var friend: BirthdayBoy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        playerNameTextField.delegate = self
        
        yearsQuestionLabel.text = "HOW OLD\nIS\n\(friend.name)??"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let pullUpVC = segue.destination as? PullUpViewController else { return }
        friend.age = friendsAge
        friend.wellWisher = playerNameTextField.text ?? "Anonymous"
        pullUpVC.friend = friend
    }
    
    @IBAction func nextButtonHasPressed(_ sender: Any) {
        
    }
    
    
   
    

}

extension NextViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        friendsAge = row + 1
        return "\(friendsAge)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        friendsAgeLabel.text = "\(row + 1)"
    }
    
    
}

extension NextViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
