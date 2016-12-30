//
//  TrackInfoParser.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/22/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation

class TrackInfoParser {
    let rawTrackInfo: String
    
    var title: String?
    var artist: String?
    
    init(rawTrackInfo: String) {
        self.rawTrackInfo = rawTrackInfo
        parse()
    }
    
    private func parse() {
        var stringParts = [String]()
        if rawTrackInfo.range(of: " - ") != nil {
            stringParts = rawTrackInfo.components(separatedBy: " - ")
        } else {
            stringParts = rawTrackInfo.components(separatedBy: "-")
        }
        
        // Set artist & songvariables
        artist = stringParts[0]
        title = stringParts[0]

        if stringParts.count > 1 {
            title = stringParts[1]
        }
    }
}
