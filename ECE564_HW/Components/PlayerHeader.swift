//
//  PlayerHeader.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/21.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class PlayerHeader: UIView {

    
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 0, y: 70))
        p.addLine(to: CGPoint(x: 245, y: 70))
        UIColor(red: 50/255, green: 190/255, blue: 255/255, alpha: 1.00).setStroke()
        p.lineWidth = 3
        p.stroke()
        
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        
        let myAttributes = [NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 35)!, .foregroundColor: UIColor(red: 80/255, green: 60/255, blue: 245/255, alpha: 1.00), NSAttributedString.Key.shadow: myShadow] as [NSAttributedString.Key : Any]
        
        let attString = NSAttributedString(string: "Music Player", attributes: myAttributes)
        attString.draw(at: CGPoint(x: 30,y: 25))
    }
    

}
