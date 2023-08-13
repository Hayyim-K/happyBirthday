//
//  HappyBirthdayViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 14/07/2023.
//

import UIKit

class HappyBirthdayViewController: UIViewController {
    
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var resultLable: UILabel!
    @IBOutlet weak var present: UILabel!
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    var friend: BirthdayBoy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = juicyColores.randomElement()
        face.image = friend.image
        present.text = presents.randomElement()
        finalLabel.text = "HAPPY BIRTHDAY\nDEAR\n\(friend.name)!!"
        resultLable.text = "I HAVE BEEN WIPING MY PHONE SCREEN ALMOST TO THE HOLES TO PLEASE YOU!!\n\nYOUR \(friend.wellWisher).."
        
    }
    
    func takeScreenshotOfView(_ view: UIView) -> UIImage? {
        shareButton.isHidden = true
        resultLable.frame.origin.y = view.frame.height - resultLable.frame.height - 8
        returnButton.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        shareButton.isHidden = false
        returnButton.isHidden = false
        return screenshot
    }
    
    @IBAction func shareButtonePressed(_ sender: UIButton) {
        
        guard let postcard = takeScreenshotOfView(view) else { return }
        let activity = UIActivityViewController(
            activityItems: [postcard],
            applicationActivities: nil
        )
        activity.popoverPresentationController?.sourceView = sender
        present(activity, animated: true)
    }
    
    
    @IBAction func returnToBegining(_ sender: Any) {
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            delegate.window?.rootViewController = initialViewController
        }
        
    }
    
}
