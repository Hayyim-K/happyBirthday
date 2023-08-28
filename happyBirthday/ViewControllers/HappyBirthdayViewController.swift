//
//  HappyBirthdayViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 14/07/2023.
//

import UIKit
import AudioToolbox

class HappyBirthdayViewController: UIViewController {
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var resultLable: UILabel!
    @IBOutlet weak var present: UILabel!
    
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var qrCodeEPP: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    var friend: BirthdayBoy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = juicyColores.randomElement()
        face.image = friend.image
        present.text = presents.randomElement()
        finalLabel.text = "HAPPY BIRTHDAY\nDEAR\n\(friend.name)!!"
        resultLable.text = friend.wellWisher.contains(",") ?
        "WE HAVE BEEN WIPING MY PHONE SCREEN ALMOST TO THE HOLES TO PLEASE YOU!!\n\nYOUR \(friend.wellWisher).." :
        "I HAVE BEEN WIPING MY PHONE SCREEN ALMOST TO THE HOLES TO PLEASE YOU!!\n\nYOUR \(friend.wellWisher).."
        setTheLogo()
        
    }

    
    private func setTheLogo() {
        logo.frame.size = CGSize(width: 226, height: 34)
        logo.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        logo.frame.origin.x = -logo.frame.width / 2 + 8
        logo.frame.origin.y = 80
    }
    
    private func takeScreenshotOfView(_ view: UIView) -> UIImage? {
        shareButton.isHidden = true
        returnButton.isHidden = true
        qrCodeEPP.isHidden = false
        
        logo.isHidden = false
        resultLable.frame.origin.y = view.frame.height - resultLable.frame.height - 8
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        qrCodeEPP.isHidden = true
        shareButton.isHidden = false
        returnButton.isHidden = false
        
        return screenshot
    }
    
    @IBAction func shareButtonePressed(_ sender: UIButton) {
        
        UISelectionFeedbackGenerator().selectionChanged()
        
        guard let postcard = takeScreenshotOfView(view) else { return }
        
        let activity = UIActivityViewController(
            activityItems: [postcard],
            applicationActivities: nil
        )
        activity.popoverPresentationController?.sourceView = sender
        present(activity, animated: true)
    }
    
    
    @IBAction func returnToBegining(_ sender: Any) {
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            delegate.window?.rootViewController = initialViewController
        }
        
    }
    
}
