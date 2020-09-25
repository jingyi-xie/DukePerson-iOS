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
    
    var noteImgView = UIImageView()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the swipe gesture recognizer
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showFront))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showFront))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        
        if currentPerson != nil {
            if self.currentPerson!.firstName!.lowercased() == "jingyi" && self.currentPerson!.lastName!.lowercased() == "xie" {
                showMine()
            }
            else {
                showOthers()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.currentPerson != nil && self.currentPerson!.firstName!.lowercased() == "jingyi" && self.currentPerson!.lastName!.lowercased() == "xie" {
            moveNoteImg()
        }
        
    }
    
    func moveNoteImg() {
        noteImgView.image = #imageLiteral(resourceName: "note")
        noteImgView.frame = CGRect(x: 50, y: 165, width: 50, height: 50)
        UIView.animate(withDuration: 2.0, delay: 0,
                       options: [.repeat, .autoreverse], animations: {
                        self.noteImgView.frame.origin.x += 200
        })
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
        
        // set up header, a UIView that has the draw method
        let header = PlayerHeader()
        header.frame = CGRect(x: 80, y: 35, width: 350, height: 200)
        header.backgroundColor = .clear
        
        // set up chat bubble: graphic context
        let gcv2Frame = CGRect(x: 25, y: 265, width: 350, height: 300)
        
        UIGraphicsBeginImageContextWithOptions(gcv2Frame.size, false, 0.0)
        
        let leftPath:UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width: 300, height: 50), byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        UIColor(red: 60/255, green: 240/255, blue: 200/255, alpha: 0.50).set()
        leftPath.fill()
        let leftChat = NSAttributedString(string: "You can click a button to play music!", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 15)!, .underlineStyle: NSUnderlineStyle.single.rawValue])
        leftChat.draw(at: CGPoint(x: 30,y: 25))
        
        let rightPath:UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 200, y: 85, width: 100, height: 50), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))
        UIColor(red: 66/255, green: 120/255, blue: 240/255, alpha: 0.50).set()
        rightPath.fill()
        let rightChat = NSAttributedString(string: "Great!", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 15)!, .underlineStyle: NSUnderlineStyle.single.rawValue])
        rightChat.draw(at: CGPoint(x: 225,y: 100))
        
        let saveImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let chatImgView = UIImageView()
        chatImgView.frame = gcv2Frame
        chatImgView.image = saveImage
        
        // set up the star
        let startFrame = CGRect(x: 25, y: 50, width: 80, height: 80)
        
        UIGraphicsBeginImageContextWithOptions(startFrame.size, false, 0.0)
        
        let star = UIBezierPath()
        star.move(to: CGPoint(x: 0, y: 40))
        star.addLine(to: CGPoint(x: 30, y: 30))
        star.addLine(to: CGPoint(x: 40, y: 0))
        star.addLine(to: CGPoint(x: 50, y: 30))
        star.addLine(to: CGPoint(x: 80, y: 40))
        star.addLine(to: CGPoint(x: 50, y: 50))
        star.addLine(to: CGPoint(x: 40, y: 80))
        star.addLine(to: CGPoint(x: 30, y: 50))
        star.addLine(to: CGPoint(x: 0, y: 40))

        UIColor(red: 50/255, green: 190/255, blue: 255/255, alpha: 1.00).setStroke()
        star.lineWidth = 3
        star.stroke()
        
        let starImg:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let starImgView = UIImageView()
        starImgView.frame = startFrame
        starImgView.image = starImg
        
        
        // set up buttons
        let attributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 30)!]
        
        let DoBtn = UIButton()
        DoBtn.frame = CGRect(x: 25, y: 525, width: 100, height: 100)
        DoBtn.layer.cornerRadius = 50
        DoBtn.layer.borderWidth = 2
        DoBtn.backgroundColor = UIColor(red: 0/255, green: 158/255, blue: 249/255, alpha: 1.00)
        DoBtn.setAttributedTitle(NSAttributedString(string: "Do", attributes: attributes), for: .normal)
        DoBtn.addTarget(self, action: #selector(clickDo(_:)), for: .touchUpInside)

        let ReBtn = UIButton()
        ReBtn.frame = CGRect(x: 135, y: 525, width: 100, height: 100)
        ReBtn.layer.cornerRadius = 50
        ReBtn.layer.borderWidth = 2
        ReBtn.backgroundColor = UIColor(red: 92/255, green: 168/255, blue: 148/255, alpha: 1.00)
        ReBtn.setAttributedTitle(NSAttributedString(string: "Re", attributes: attributes), for: .normal)
        ReBtn.addTarget(self, action: #selector(clickRe(_:)), for: .touchUpInside)
        
        let MiBtn = UIButton()
        MiBtn.frame = CGRect(x: 245, y: 525, width: 100, height: 100)
        MiBtn.layer.cornerRadius = 50
        MiBtn.layer.borderWidth = 2
        MiBtn.backgroundColor = UIColor(red: 200/255, green: 40/255, blue: 200/255, alpha: 1.00)
        MiBtn.setAttributedTitle(NSAttributedString(string: "Mi", attributes: attributes), for: .normal)
        MiBtn.addTarget(self, action: #selector(clickMi(_:)), for: .touchUpInside)
        
        view.addSubview(header)
        view.addSubview(DoBtn)
        view.addSubview(ReBtn)
        view.addSubview(MiBtn)
        view.addSubview(noteImgView)
        view.addSubview(chatImgView)
        view.addSubview(starImgView)
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
