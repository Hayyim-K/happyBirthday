//
//  ImageSettingsViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 05/08/2023.
//

import UIKit

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
    var completionHandler: ((UIImage) ->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        avatar.image = image
        updateMinZoomScaleForSize()
        updateConstraintsForSize(scrollView.bounds.size)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize()
    }
    
    func takeScreenshotOfView(_ view: UIView) -> UIImage? {
        ear.isHidden = true
        rightEar.isHidden = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
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
    
    @IBAction func doneButtonHasPressed(_ sender: Any) {
        dismiss(animated: true) {
            guard let screenShot = self.takeScreenshotOfView(self.view)
            else { return }
            
            guard let finalImage = self.cropImage(
                screenShot,
                toRect: self.grid.frame
            )
            else { return }
            
            self.completionHandler(finalImage)
        }
    }
    
    @IBAction func cancelbuttonHasPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ImageSettingsViewController: UIScrollViewDelegate {
    
    func updateMinZoomScaleForSize() {
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 10
    }
    
    func updateConstraintsForSize(_ size: CGSize) {
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
