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
    
    var friend: BirthdayBoy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finalLabel.text = "HAPPY BIRTHDAY\nDEAR\n\(friend.name)!!"
        resultLable.text = "I HAVE BEEN WIPPING THE PHONE SCREEN ALMOST TO THE HOLES TO PLEASE YOU!!\n\nYOUR \(friend.wellWisher).."
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
