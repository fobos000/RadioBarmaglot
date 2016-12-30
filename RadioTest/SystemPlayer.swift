//
//  SystemPlayer.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/22/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class SystemPlayer {
    
    class func setCurrentTrack(title: String?, artist: String?, image: UIImage? = nil) {
        let albumArtwork = MPMediaItemArtwork(image: #imageLiteral(resourceName: "albumArt"))
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: artist!,
            MPMediaItemPropertyTitle: title!,
            MPMediaItemPropertyArtwork: albumArtwork
        ]
    }
    
    class func setCurrentArtwork(data: Data) {
        if let artworkImage = UIImage(data: data) {
            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
            if let nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo {
                var playingInfo = nowPlayingInfo
                let albumArtwork = MPMediaItemArtwork(image: artworkImage)
                playingInfo[MPMediaItemPropertyArtwork] = albumArtwork
                nowPlayingInfoCenter.nowPlayingInfo = playingInfo
            }
        }
    }
}
