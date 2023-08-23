//
//  ImageSettingsViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 05/08/2023.
//

import UIKit
import CoreImage

class ImageSettingsViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var grid: UIImageView!
    @IBOutlet weak var ear: UIImageView!
    @IBOutlet weak var rightEar: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarBottomConstraint: NSLayoutConstraint!
    
    var image: UIImage!
    var completionHandler: ((UIImage, Bool) ->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISelectionFeedbackGenerator().selectionChanged()
        scrollView.delegate = self
        avatar.image = image
        updateMinZoomScaleForSize()
        updateConstraintsForSize(scrollView.bounds.size)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize()
    }
    
    private func takeScreenshotOfView(_ view: UIView) -> UIImage? {
        ear.isHidden = true
        rightEar.isHidden = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    private func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        image.draw(at: .zero)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ear.isHidden = false
        rightEar.isHidden = false
        
        return croppedImage
        
    }
    
    
    private func oilPaint(image: UIImage, sigma: CGFloat) -> UIImage {

      // Convert the image to grayscale.
        let grayscaleImage = CIImage(image: image)!.applyingFilter("CIColorMonochrome", parameters: [kCIInputIntensityKey: 1.0])

      // Apply a Gaussian blur to the grayscale image.
      let blurredImage = grayscaleImage.applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: sigma])

      // Mix the blurred image with the original image.
        let oilPaintedImage = blurredImage.applyingFilter("CILinearDodgeCompositing")

      // Convert the image back to UIImage.
      return UIImage(ciImage: oilPaintedImage)
    }
    
    private func setFilter(on image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        
        // Create a CIFilter to apply a Gaussian blur.
        let blurFilter = CIFilter(name: "CIColorMonochrome")!
        blurFilter.setValue(ciImage, forKey: "inputImage")
        blurFilter.setValue(CIColor(red: 1, green: 1, blue: 0.2, alpha: 1), forKey: "inputColor")
        
        // Apply the blur filter to the image.
        let blurredImage = blurFilter.outputImage
        
        // Create a CIFilter to apply a color dodge blend mode.
        let blendFilter = CIFilter(name: "CICrystallize")!
        blendFilter.setValue(blurredImage, forKey: "inputImage")
        blendFilter.setValue(22, forKey: "inputRadius")
        blendFilter.setValue(CIVector(cgPoint: CGPoint(x: -168, y: 280)), forKey: "inputCenter")
        
        // Apply the blend filter to the image.
        if let oilPaintedImage = blendFilter.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(oilPaintedImage, from: oilPaintedImage.extent) {
                
                // Convert the CIImage to a UIImage.
                let uiImage = UIImage(cgImage: cgImage)
                
//                let targetSize = CGSize(width: 169, height: 281)
//
//                UIGraphicsBeginImageContextWithOptions(targetSize, true, 1.0)
//
//                uiImage.draw(in: CGRect(origin: .zero, size: targetSize))
//
//                if let resultImage = UIGraphicsGetImageFromCurrentImageContext() {
//                    UIGraphicsEndImageContext()
                    return uiImage
//                }
            }
        }
        return image
    }
    
    
    @IBAction func doneButtonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        dismiss(animated: true) {
            guard let screenShot = self.takeScreenshotOfView(self.view)
            else { return }
            
            guard let cropedImage = self.cropImage(
                screenShot,
                toRect: self.grid.frame
            )
            else { return }
//            var finalImage = self.oilPaint(image: cropedImage, sigma: 5)
//            let finalImage = self.setFilter(on: cropedImage)
//            print(cropedImage.size, finalImage.size)
            self.completionHandler(cropedImage, false)
        }
    }
    
    @IBAction func cancelbuttonHasPressed(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        dismiss(animated: true)
    }
    
    
    @IBAction func paintButtonTapped(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        dismiss(animated: true) {
            guard let screenShot = self.takeScreenshotOfView(self.view)
            else { return }
            
            guard let cropedImage = self.cropImage(
                screenShot,
                toRect: self.grid.frame
            )
            else { return }
//            var finalImage = self.oilPaint(image: cropedImage, sigma: 5)
//            let finalImage = self.setFilter(on: cropedImage)
//            print(cropedImage.size, finalImage.size)
            self.completionHandler(cropedImage, true)
        }
    }
    
}

extension ImageSettingsViewController: UIScrollViewDelegate {
    
    private func updateMinZoomScaleForSize() {
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 10
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - avatar.frame.height) / 2)
        avatarTopConstraint.constant = yOffset
        avatarBottomConstraint.constant = yOffset
        let xOffset = max(0, (size.width - avatar.frame .width) / 2)
        avatarLeadingConstraint.constant = xOffset
        avatarTrailingConstraint.constant = xOffset
        view.layoutIfNeeded()
    }
    
    func scrollViewDidZoom (_ scrollView: UIScrollView) {
        updateConstraintsForSize(scrollView.bounds.size)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        avatar
    }
    
}


