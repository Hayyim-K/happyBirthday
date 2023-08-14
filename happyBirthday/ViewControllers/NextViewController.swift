//
//  NextViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 11/07/2023.
//

import UIKit

class NextViewController: UIViewController {
    
    @IBOutlet weak var yearsQuestionLabel: UILabel!
    @IBOutlet weak var friendsAgeLabel: UILabel!
    @IBOutlet weak var yearsPickerView: UIPickerView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var friend: BirthdayBoy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearsQuestionLabel.text = "HOW OLD\nIS\n\(friend.name)??"
        friendsAgeLabel.text = "1"
        setupKeyboardHiding()
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(
            self,
            selector:
                #selector (keyboardWillShow),
            name:
                UIResponder.keyboardWillShowNotification,
            object:
                nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector:
                #selector (keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object:
                nil
        )
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        
        UISelectionFeedbackGenerator().selectionChanged()
        
        guard let userinfo = sender.userInfo,
              let keyboardFrame = userinfo[
                UIResponder.keyboardFrameEndUserInfoKey
              ] as? NSValue else { return }
        if keyboardFrame.cgRectValue.origin.y < userNameTextField.frame.origin.y + userNameTextField.frame.height + 8 {
            view.frame.origin.y = keyboardFrame.cgRectValue.origin.y - userNameTextField.frame.origin.y - userNameTextField.frame.height - 8
        }
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
    }
    
    @IBAction func nextButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        friend.age = Int(friendsAgeLabel.text!)!
        
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
        
        pullUpVC.friend = friend
        
        present(pullUpVC, animated: true)
    }
    
}

