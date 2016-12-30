//
//  AppCoordinator.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/12/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    var radioView: RadioViewInput
    var player: AVRadioPlayer
    
    init(view: RadioViewInput, player: AVRadioPlayer) {
        self.radioView = view
        self.player = player
    }
    
    func start() {
        
    }
}

extension AppCoordinator: RadioViewOutput {
    func handleViewReady(view: UIView) {
        player.configureWith(view: view)
    }
    
    func tappedPlayPause() {
        if player.isPlaying {
            player.stop()
        } else {
            player.play()
        }
    }
    
    func tappedPlay() {
        player.play()
        Analytics.logTapButton(name: "Play")
    }
    
    func tappedPause() {
        player.stop()
        Analytics.logTapButton(name: "Stop")
    }
    
    func tappedFacebook() {
        let url = URL(string: "fb://profile/1246450212033897")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/barmaglot.radio/")!)
        }
        Analytics.logTapButton(name: "Facebook")
    }
    
    func tappedVK() {
        let url = URL(string: "vk://vk.com/barmaglot.radio")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            UIApplication.shared.openURL(URL(string: "https://vk.com/barmaglot.radio")!)
        }
        Analytics.logTapButton(name: "VK")
    }
    
    func tappedMail() {
        let email = "info@radiobarmaglot.com"
        let url = URL(string: "mailto:\(email)")!
        UIApplication.shared.openURL(url)
        Analytics.logTapButton(name: "Mail")
    }
}

extension AppCoordinator: RadioPlayerOutput {
    func discoveredTrackInfo(info: String) {
        radioView.setTrackInfo(trackInfo: info)
        let parser = TrackInfoParser(rawTrackInfo: info)
        SystemPlayer.setCurrentTrack(title: parser.title, artist: parser.artist)
        
        let trackMetadata = TrackMetadata(title: parser.title, artist: parser.artist)
        let artworkLoader = iTunesAlbumArtworkLoader(trackMetadata: trackMetadata)
        artworkLoader.output = self
        artworkLoader.loadArtwork()
    }
    
    internal func didStartLoading() {
        radioView.displayLoading()
    }
    
    func didStart() {
        radioView.hideLoading()
        radioView.displayPause()
    }
    
    func didStop() {
        radioView.displayPlay()
    }
}

extension AppCoordinator: AlbumArtworkLoaderOutput {
    func didLoadArtwork(data: Data) {
        SystemPlayer.setCurrentArtwork(data: data)
    }
    
    func didFailToLoadArtwork() {
        
    }
}
