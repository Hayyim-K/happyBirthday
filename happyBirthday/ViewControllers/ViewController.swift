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
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
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
        imageSetVC.completionHandler = { [weak self] image, isPaintTapped in
            
            self?.friendsAvatar.image = image
            
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            if isPaintTapped {
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
                self?.showPaintViewController()
            }
            
        }
        present(imageSetVC, animated: true)
    }
    
    private func showPaintViewController() {
        let showPaintVC = self.storyboard?.instantiateViewController(withIdentifier: "PencilKitViewController") as! PencilKitViewController
        showPaintVC.modalPresentationStyle = .overCurrentContext
        showPaintVC.providesPresentationContextTransitionStyle = true
        showPaintVC.definesPresentationContext = true
        showPaintVC.modalTransitionStyle = .crossDissolve
        showPaintVC.image = friendsAvatar.image
        showPaintVC.completionHandler = { [weak self] image in

            self?.friendsAvatar.image = image

            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
        present(showPaintVC, animated: true)
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
                style: .cancel,
                handler: { _ in
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
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
