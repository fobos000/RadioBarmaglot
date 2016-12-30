//
//  RadioPlayerOutput.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/22/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation
protocol RadioPlayerOutput {
    func discoveredTrackInfo(info: String)
    func didStart()
    func didStop()
    func didStartLoading()
}
