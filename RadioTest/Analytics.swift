//
//  Analytics.swift
//  RadioTest
//
//  Created by O.Ohorbach on 11/18/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation
import Firebase

class Analytics {
    class func logTapButton(name: String) {
        let eventName = "TapButton_".appending(name)
        FIRAnalytics.logEvent(withName: eventName, parameters: nil)
    }
}
