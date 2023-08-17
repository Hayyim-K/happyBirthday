//
//  ViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 10/07/2023.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var friendsNameTextField: UITextField!
    @IBOutlet weak var friendsAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        arrow.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 6.5 )
        
        friendsAvatar.image = UIImage(named: ["face35", "face65cuted"].randomElement()!)
        
        friendsNameTextField.layer.add(pulse(), forKey: "pulse")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.friendsAvatar.layer.add(self.pulse(), forKey: "pulse")
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.stopAnimating()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextVC = segue.destination as? NextViewController else { return }
        
        let friendsName = friendsNameTextField.text?.uppercased() ?? "FRIEND"
        
        let avatar = friendsAvatar.image ?? UIImage(named: "face35")
        
        let friend = BirthdayBoy(
            name: friendsName == "" ? "FRIEND" : friendsName,
            image: avatar!,
            age: 18,
            wellWisher: "ANONYMOUS"
        )
        nextVC.friend = friend
    }
    
    // Observe changes in the presentedViewController property
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(UIViewController.presentedViewController) {
//            if imagePicker.presentingViewController == nil {
//                // Image picker was dismissed
//                activityIndicator.stopAnimating()
//                activityIndicator.removeFromSuperview()
//            }
//        }
//    }
    
//    deinit {
//            // Remove observer when the view controller is deallocated
//            imagePicker.removeObserver(self, forKeyPath: #keyPath(UIViewController.presentedViewController))
//        }
    
    private func pulse() -> CAAnimation {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.3
        pulseAnimation.fromValue = 0.99
        pulseAnimation.toValue = 1.01
        pulseAnimation.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeInEaseOut
        )
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 5
        return pulseAnimation
    }
    
    
    @IBAction func nextButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
        UISelectionFeedbackGenerator().selectionChanged()
        showImageMenu()
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


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func presetCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true)
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen

        
        // Add observer for the "presentedViewController" key path
        imagePicker.addObserver(self, forKeyPath: #keyPath(UIViewController.presentedViewController), options: [.old, .new], context: nil)
        
        //        // Add a gesture recognizer to detect swipe gesture
        //        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        //        swipeGesture.direction = .down
        //        imagePicker.view.addGestureRecognizer(swipeGesture)
        
        present(imagePicker, animated: true)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            friendsAvatar.image = pickedImage
        }
        picker.dismiss(animated: true) {
            self.showImageSettings()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}

extension ViewController {
    
    private func showImageSettings() {
        let imageSetVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageSettingsViewController") as! ImageSettingsViewController
        imageSetVC.modalPresentationStyle = .overCurrentContext
        imageSetVC.providesPresentationContextTransitionStyle = true
        imageSetVC.definesPresentationContext = true
        imageSetVC.modalTransitionStyle = .crossDissolve
        imageSetVC.image = friendsAvatar.image
        imageSetVC.completionHandler = { [weak self] image in
            
            self?.friendsAvatar.image = image
            
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
        present(imageSetVC, animated: true)
    }
    
    private func showImageMenu() {
        let alert = UIAlertController(
            title: "Profile Picture",
            message: "How would you like to select a picture?",
            preferredStyle: .actionSheet
        )
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: 0, y: self.view.bounds.height, width: 1, height: 1)
        }
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Take Photo",
                style: .default,
                handler: { [weak self] _ in
                    
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                    
                    self?.presetCamera()
                    
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Choose Photo",
                style: .default,
                handler: { [weak self] _ in
                    
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                    
                    self?.showImagePicker()
                    
                }
            )
        )
        
        present(alert, animated: true)
    }
    
}

//extension ViewController {
//
//    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.state == .ended {
//            // Stop the activity indicator
//            activityIndicator.stopAnimating()
//            activityIndicator.isHidden = true
//        }
//    }
//
//}
