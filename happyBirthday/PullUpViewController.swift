//
//  PullUpViewController.swift
//  happyBirthday
//
//  Created by vitasiy on 13/07/2023.
//

import UIKit

class PullUpViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    
    var friend: BirthdayBoy!
     
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = "PULL IT UP\n\(friend.age)\nTIMES!!"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pullEarsUp(_ sender: UIButton) {
        
    }
}
