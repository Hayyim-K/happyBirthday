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
        
        friendsNameTextField.layer.add(pulse(), forKey: "pulse")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.friendsAvatar.layer.add(self.pulse(), forKey: "pulse")
        }
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
        
    }
    
    
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
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
    
    func showImageMenu() {
        let alert = UIAlertController(
            title: "Profile Picture",
            message: "How would you like to select a picture?",
            preferredStyle: .actionSheet
        )
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
                    self?.presetCamera()
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Choose Photo",
                style: .default,
                handler: { [weak self] _ in
                    self?.showImagePicker()
                }
            )
        )
        present(alert, animated: true)
    }
    
    func presetCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            
            //            // Применяем фильтры к изображению
            //            let filteredImage = applyFilters(to: pickedImage)
            //
            //            // Изменяем размер изображения
            //            let resizedImage = resizeImage(image: filteredImage, targetSize: CGSize(width: 300, height: 300))
            //
            //            // Обрезаем изображение (если необходимо)
            //            let croppedImage = cropImage(image: resizedImage, rect: CGRect(x: 50, y: 50, width: 200, height: 200))
            
            friendsAvatar.image = pickedImage
            
        }
        picker.dismiss(animated: true) {
            self.showImageSettings()
        }
    }
    /*
     // Применение фильтров к изображению
     func applyFilters(to image: UIImage) -> UIImage {
     guard let ciImage = CIImage(image: image) else {
     return image
     }
     
     let context = CIContext()
     
     // Применяем фильтры (здесь применяется Core Image фильтр Sepia Tone)
     if let filter = CIFilter(name: "CISepiaTone") {
     filter.setValue(ciImage, forKey: kCIInputImageKey)
     filter.setValue(0.8, forKey: kCIInputIntensityKey)
     
     if let outputCIImage = filter.outputImage,
     let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
     return UIImage(cgImage: cgImage)
     }
     }
     
     return image
     }
     
     // Метод для изменения размера изображения
     func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
     let size = image.size
     let widthRatio = targetSize.width / size.width
     let heightRatio = targetSize.height / size.height
     let newSize = widthRatio > heightRatio ?
     CGSize(width: size.width * heightRatio, height: size.height * heightRatio) :
     CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
     
     let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
     
     UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
     image.draw(in: rect)
     let newImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     
     return newImage ?? image
     }
     
     // Метод для обрезки изображения
     func cropImage(image: UIImage, rect: CGRect) -> UIImage {
     guard let cgImage = image.cgImage else {
     return image
     }
     
     guard let croppedCGImage = cgImage.cropping(to: rect) else {
     return image
     }
     
     return UIImage(cgImage: croppedCGImage)
     }
     */
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
            print(image.size)
            self?.friendsAvatar.image = image
        }
        present(imageSetVC, animated: true)
    }
}

