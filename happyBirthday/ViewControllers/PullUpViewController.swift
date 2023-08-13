//
//  PullUpViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 13/07/2023.
//

import UIKit

class PullUpViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var ears: UIButton!
    
    var friend: BirthdayBoy!
    
    private var currentPull = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentPull)
        avatar.image = friend.image
        currentPull = friend.age
        infoLabel.text = "PULL IT UP\n\(currentPull)\nTIMES!!"
        
        //
        
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        guard let happyVC = segue.destination as? HappyBirthdayViewController else { return }
    //        happyVC.friend = friend
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func pullEarsUp(_ sender: UIButton) {
        view.backgroundColor = juicyColores.randomElement()
        currentPull -= 1
        infoLabel.text = "PULL IT UP\n\(currentPull)\nTIMES!!"
        
        let age = Double(friend.age)
        if currentPull <= 0 {
            moveOn()
            return
        }
        switch Double(currentPull) {
        case age * 0.5...age * 0.75:
            ears.setImage(
                UIImage(named: "activeEarsHQ"),
                for: .normal
            )
            ears.setImage(
                UIImage(named: "activeEarsUpped"),
                for: .highlighted
            )
        case age * 0.25...age * 0.499:
            ears.setImage(
                UIImage(named: "NotRedYetEarsHQ"),
                for: .normal
            )
            ears.setImage(
                UIImage(named: "NotRedYetEarsUpped"),
                for: .highlighted
            )
        case 0...age * 0.2499:
            ears.setImage(
                UIImage(named: "RedEarsHQ"),
                for: .normal
            )
            ears.setImage(
                UIImage(named: "RedEarsUpped"),
                for: .highlighted
            )
            
        default:
            ears.setImage(
                UIImage(named: "unactiveEarsHQ"),
                for: .normal
            )
            ears.setImage(
                UIImage(named: "unactiveEarsUpped"),
                for: .highlighted
            )
        }
    }
}

extension PullUpViewController {
    
    private func moveOn() {
        let happyVC = self.storyboard?.instantiateViewController(withIdentifier: "HappyBirthdayViewController") as! HappyBirthdayViewController
        happyVC.modalPresentationStyle = .overCurrentContext
        happyVC.providesPresentationContextTransitionStyle = true
        happyVC.definesPresentationContext = true
        happyVC.modalTransitionStyle = .crossDissolve
        
        happyVC.friend = friend
        
        present(happyVC, animated: true)
    }
    
}
