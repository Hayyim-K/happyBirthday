//
//  AboutUsViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 13/08/2023.
//

import UIKit
import AudioToolbox

class AboutUsViewController: UIViewController {
    
    @IBAction func visitWebSite(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        if let url = URL(string: "https://b2banalytica.wixsite.com/primitivedevelopment") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func visitOurAppStore(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        if let url = URL(string: "https://apps.apple.com/developer/vitalii-kukhar/id1693449151") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func supportUs(_ sender: Any) {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
        
        let title = "This page is under development"
        let message = "Right now, it's better to support the Armed Forces of Ukraine!\nThank you."
        
        showAlert(title: title, message: message)
    }
    
    
    @IBAction func backToApp(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            delegate.window?.rootViewController = initialViewController
        }
    }
}

extension AboutUsViewController {
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Support Ukraine",
                                     style: .default) { _ in
            if let url = URL(string: "https://war.ukraine.ua/support-ukraine/") {
                UIApplication.shared.open(url)
            }
        }
        
        let hayyimAction = UIAlertAction(title: "Support Us",
                                     style: .default) { _ in
            if let url = URL(string: "https://www.buymeacoffee.com/hayyim") {
                UIApplication.shared.open(url)
            }
        }
        
        let noAction = UIAlertAction(title: "Not now", style: .default)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
    
    
    
}




