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
    @IBOutlet weak var userNameTextField: UITextField!
    
    var friend: BirthdayBoy!
    
//    private var currentPull = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearsQuestionLabel.text = "HOW OLD\nIS\n\(friend.name)??"
        friendsAgeLabel.text = "1"
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        guard let pullUpVC = segue.destination as? PullUpViewController else { return }
    //        friend.age = Int(friendsAgeLabel.text!)!
    //
    //        if let userName = userNameTextField.text {
    //            friend.wellWisher = userName == "" ? "ANONYMOUS" : userName
    //        } else {
    //            friend.wellWisher = "ANONYMOUS"
    //        }
    //
    //        pullUpVC.friend = friend
    //    }
    
    @IBAction func nextButtonHasPressed(_ sender: Any) {
        friend.age = Int(friendsAgeLabel.text!)!
//        currentPull = friend.age
        
        if let userName = userNameTextField.text {
            friend.wellWisher = userName == "" ? "ANONYMOUS" : userName.uppercased()
        } else {
            friend.wellWisher = "ANONYMOUS"
        }
            showPullUpVC()
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
        emojiRange.randomElement() ?? "🎂"
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

extension NextViewController {
    
    private func showPullUpVC() {
        let pullUpVC = self.storyboard?.instantiateViewController(withIdentifier: "PullUpViewController") as! PullUpViewController
        pullUpVC.modalPresentationStyle = .overCurrentContext
        pullUpVC.providesPresentationContextTransitionStyle = true
        pullUpVC.definesPresentationContext = true
        pullUpVC.modalTransitionStyle = .crossDissolve
//        pullUpVC.currentPull = currentPull
        pullUpVC.friend = friend
        
        present(pullUpVC, animated: true)
    }
    
}

