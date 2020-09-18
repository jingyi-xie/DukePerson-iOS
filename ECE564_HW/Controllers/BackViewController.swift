//
//  BackViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/12.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class BackViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    var currentPerson : DukePerson? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the swipe gesture recognizer
        let swipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showFront))
        swipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipe)
        
        if currentPerson != nil {
            // Set the text in name label
            nameLabel.attributedText = NSAttributedString(string: "\(self.currentPerson!.firstName!) \(self.currentPerson!.lastName!)", attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
            nameLabel.textColor = .blue
            nameLabel.font = UIFont(name: "Marker Felt", size: 30)
            // Display the image of the current person. If not found, display the default one
            if currentPerson?.img != nil {
                self.profileImg.image = UIImage(data: self.currentPerson!.img!)
            }
            else {
                self.profileImg.image = UIImage(named: "default.png")
            }
        }
    }
    
    // MARK: - Navigation

    // when goes back to information view, pass the current person
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFront" {
            let navController = segue.destination as! UINavigationController
            let dest = navController.topViewController as! InformationViewController
            dest.currentPerson = self.currentPerson
            dest.saveBtn.title = "Edit"
        }
        
    }
    @objc func showFront() {
        performSegue(withIdentifier: "showFront", sender: self)
    }
}
