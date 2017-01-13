//
//  SpinnerView.swift
//  RadioTest
//
//  Created by Ostap Horbach on 1/6/17.
//  Copyright © 2017 Ostap Horbach. All rights reserved.
//

import UIKit

class SpinnerView: AngleGradientBorderView {

    var isAnimating: Bool = false

    func startAnimating() {
        if !isAnimating {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0
            animation.toValue = 2 * M_PI
            animation.duration = 2
            animation.repeatCount = .infinity
            layer.add(animation, forKey: "spin")
            isAnimating = true
        }
    }
    
    func stopAnimating() {
        layer.removeAnimation(forKey: "spin")
        isAnimating = false
    }
}
