//
//  PencilKitViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 23/08/2023.
//

import UIKit
import PencilKit


class PencilKitViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {
    
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    var toolPicker: PKToolPicker!
    var drawing = PKDrawing()
    
    var image: UIImage!
    var completionHandler: ((UIImage) ->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatar.image = image
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        toolPicker = PKToolPicker()
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.showsDrawingPolicyControls = true
        
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        
        canvasView.becomeFirstResponder()
    }
    
    private func prepareImage() -> UIImage? {
        UIGraphicsBeginImageContext(canvasView.bounds.size)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func takeScreenshotOfView(_ view: UIView) -> UIImage? {
        addButton.isHidden = true
        undoButton.isHidden = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        undoButton.isHidden = false
        addButton.isHidden = false
        return screenshot
    }
    
    private func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        image.draw(at: .zero)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        dismiss(animated: true) {
            guard let screenShot = self.takeScreenshotOfView(self.view)
            else { return }
            
            guard let cropedImage = self.cropImage(
                screenShot,
                toRect: self.avatar.frame
            )
            else { return }
            
            self.completionHandler(cropedImage)
        }
    }
}
