//
//  BackViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/12.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import AVFoundation

class BackViewController: UIViewController {
    
    var currentPerson : DukePerson? = nil
    
    var audioPlayerDo = AVAudioPlayer()
    var audioPlayerRe = AVAudioPlayer()
    var audioPlayerMi = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the swipe gesture recognizer
        let swipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showFront))
        swipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipe)
        
        if currentPerson != nil {
            if self.currentPerson!.firstName!.lowercased() == "jingyi" && self.currentPerson!.lastName!.lowercased() == "xie" {
                showMine()
            }
            else {
                showOthers()
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
    
    func showOthers() {
        let nameLabel = UILabel()
        let profileImg = UIImageView()
        nameLabel.frame = CGRect(x: 100, y: 150, width: 300, height: 30)
        profileImg.frame = CGRect(x: 100, y: 250, width: 150, height: 150)
        
        // Set the text in name label
        nameLabel.attributedText = NSAttributedString(string: "\(self.currentPerson!.firstName!) \(self.currentPerson!.lastName!)", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        nameLabel.textColor = .blue
        nameLabel.font = UIFont(name: "Marker Felt", size: 30)
        // Display the image of the current person. If not found, display the default one
        if currentPerson?.img != nil {
            profileImg.image = UIImage(data: self.currentPerson!.img!)
        }
        else {
            profileImg.image = UIImage(named: "default.png")
        }
        
        view.addSubview(nameLabel)
        view.addSubview(profileImg)
    }
    
    func showMine() {
        // setup audio player
        let soundDo = NSURL(fileURLWithPath: Bundle.main.path(forResource: "do", ofType: "mp3")!)
        let soundRe = NSURL(fileURLWithPath: Bundle.main.path(forResource: "re", ofType: "mp3")!)
        let soundMi = NSURL(fileURLWithPath: Bundle.main.path(forResource: "mi", ofType: "mp3")!)
        do {
            audioPlayerDo = try AVAudioPlayer(contentsOf: soundDo as URL)
            audioPlayerDo.prepareToPlay()
            audioPlayerRe = try AVAudioPlayer(contentsOf: soundRe as URL)
            audioPlayerRe.prepareToPlay()
            audioPlayerMi = try AVAudioPlayer(contentsOf: soundMi as URL)
            audioPlayerMi.prepareToPlay()
        }
        catch {
            print("Failed to setup audio players")
        }
        
        // set up buttons
        let attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 30)!]
        
        let DoBtn = UIButton()
        DoBtn.frame = CGRect(x: 25, y: 500, width: 100, height: 100)
        DoBtn.layer.cornerRadius = 50
        DoBtn.layer.borderWidth = 2
        DoBtn.backgroundColor = UIColor(red: 0/255, green: 158/255, blue: 249/255, alpha: 1.00)
        DoBtn.setAttributedTitle(NSAttributedString(string: "Do", attributes: attributes), for: .normal)
        DoBtn.addTarget(self, action: #selector(clickDo(_:)), for: .touchUpInside)

        
        let ReBtn = UIButton()
        ReBtn.frame = CGRect(x: 135, y: 500, width: 100, height: 100)
        ReBtn.layer.cornerRadius = 50
        ReBtn.layer.borderWidth = 2
        ReBtn.backgroundColor = UIColor(red: 92/255, green: 168/255, blue: 148/255, alpha: 1.00)
        ReBtn.setAttributedTitle(NSAttributedString(string: "Re", attributes: attributes), for: .normal)
        ReBtn.addTarget(self, action: #selector(clickRe(_:)), for: .touchUpInside)
        
        let MiBtn = UIButton()
        MiBtn.frame = CGRect(x: 245, y: 500, width: 100, height: 100)
        MiBtn.layer.cornerRadius = 50
        MiBtn.layer.borderWidth = 2
        MiBtn.backgroundColor = UIColor(red: 200/255, green: 40/255, blue: 200/255, alpha: 1.00)
        MiBtn.setAttributedTitle(NSAttributedString(string: "Mi", attributes: attributes), for: .normal)
        MiBtn.addTarget(self, action: #selector(clickMi(_:)), for: .touchUpInside)

        let tipLabel = UILabel()
        tipLabel.attributedText = NSAttributedString(string: "Click a button to play music!", attributes: [NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20)!, .underlineStyle: NSUnderlineStyle.single.rawValue])
        tipLabel.frame = CGRect(x: 75, y: 575, width: 300, height: 100)
        
        view.addSubview(DoBtn)
        view.addSubview(ReBtn)
        view.addSubview(MiBtn)
        view.addSubview(tipLabel)
    }
    
    @objc func clickDo(_ btn: UIButton) {
        btn.animate()
        audioPlayerDo.currentTime = 0
        audioPlayerDo.play()
    }
    
    @objc func clickRe(_ btn: UIButton) {
        btn.animate()
        audioPlayerRe.currentTime = 0
        audioPlayerRe.play()
    }
    
    @objc func clickMi(_ btn: UIButton) {
        btn.animate()
        audioPlayerMi.currentTime = 0
        audioPlayerMi.play()
    }
}
