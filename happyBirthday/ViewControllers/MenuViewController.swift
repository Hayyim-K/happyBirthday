//
//  MenuViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 13/08/2023.
//

import UIKit
import LocalAuthentication

class MenuViewController: UIViewController {
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        UISelectionFeedbackGenerator().selectionChanged()
        super.viewDidLoad()
        greetingsLabel.text = greetings
    }
    
    private func startCreating() {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! ViewController
        present(firstVC, animated: true)
    }
    
    
    
    @IBAction func introductionButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @IBAction func aboutUsButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        showParentalGatesAlert(
            title: "👮‍♂️ Parental Gates 🥸\nASK YOUR PARENTS",
            message: "The content you are trying to access includes internet access via Safari. Choose an authentication method:")
    }
    
    
    @IBAction func start(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        startCreating()
    }
    
}

extension MenuViewController {
    
    private func authentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "👮‍♂️ Parental Gates 🥸"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        UISelectionFeedbackGenerator().selectionChanged()
                        self.performSegue(withIdentifier: "aboutUs", sender: nil)
                    } else {
                        if let error = authenticationError as? LAError {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        } else {
            print("Biometric authentication is unavailable")
        }
    }
    
    private func showAlertWithTextField(title: String,
                                        message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "3.14****************46"
            textField.keyboardType = .decimalPad
        }
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default) { _ in
                let text = alert.textFields?.first?.text
                if text == "3,14159265358979323846" ||
                    text == "3.14159265358979323846" ||
                    text == "14159265358979323846" ||
                    text == ".14159265358979323846" ||
                    text == "1592653589793238" {
                    UISelectionFeedbackGenerator().selectionChanged()
                    self.performSegue(withIdentifier: "aboutUs", sender: nil)
                } else {
                    self.showAlert(title: "🚼 🐣 👶 🤭",
                                   message: "You should call your parents, my little friend!")
                }
            }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showParentalGatesAlert(title: String,
                                        message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let faceIDAction = UIAlertAction(
            title: "FaceID / TouchID",
            style: .default) { _ in
                self.authentication()
            }
        
        let piAction = UIAlertAction(
            title: "Input the 20 Digits of Pi",
            style: .default) { _ in
                self.showAlertWithTextField(
                    title: "👮‍♂️ Parental Gates 🥸",
                    message: "Enter the first 20 digits of π(pi) after the decimal point"
                )
            }
        
        alert.addAction(faceIDAction)
        alert.addAction(piAction)
        present(alert, animated: true)
    }
    
    private func showAlert(title: String,
                           message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default) { _ in
                self.startCreating()
            }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}
