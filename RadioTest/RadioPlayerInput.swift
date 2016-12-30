//
//  RadioPlayerInput.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/22/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation
import UIKit

protocol RadioPlayerInput {
    func play()
    func stop()
    
    var isPlaying: Bool {get}
    
    var output: RadioPlayerOutput? {get set}
}

protocol AVRadioPlayer: RadioPlayerInput {
    func configureWith(view: UIView)
}
