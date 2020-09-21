//
//  UIButtonExtension.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/21.
//  Copyright © 2020 ECE564. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func animate() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.9
        animation.toValue = 1
        animation.duration = 0.5
        animation.autoreverses = true
        animation.initialVelocity = 0.5
        animation.damping = 1.0
        layer.add(animation, forKey: nil)
    }
}
