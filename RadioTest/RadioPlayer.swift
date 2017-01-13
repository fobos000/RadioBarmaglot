//
//  RadioPlayer.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/22/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import AVFoundation
import UIKit

class RadioPlayer: NSObject, AVRadioPlayer {
    private var player = AVPlayer()
    private var playerURL: URL
    var output: RadioPlayerOutput?
    
    var isPlaying: Bool {
        return player.status == .readyToPlay
    }
    
    init(url: URL) {
        self.playerURL = url
        super.init()
        
        configureAudioSession()
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error {
            debugPrint("audioSession setCategory error \(error)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("audioSession setActive error \(error)")
        }
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name.AVAudioSessionInterruption, object: nil, queue: OperationQueue.main) {
            notification in
            
            if let interruptionType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] {
                var intValue: UInt = 0
                (interruptionType as! NSValue).getValue(&intValue)
                switch AVAudioSessionInterruptionType(rawValue: intValue)! {
                case .began:
                    self.output?.didStop()
                case .ended:
                    if let interruptionOption = notification.userInfo?[AVAudioSessionInterruptionOptionKey] {
                        var intValue: UInt = 0
                        (interruptionOption as! NSValue).getValue(&intValue)
                        if AVAudioSessionInterruptionOptions(rawValue: intValue) == AVAudioSessionInterruptionOptions.shouldResume {
                            self.play()
                        }
                    }
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVAudioSessionRouteChange, object: nil, queue: OperationQueue.main) {
            notification in
            if let changeReasonRaw = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt,
                let changeReason = AVAudioSessionRouteChangeReason(rawValue: changeReasonRaw) {
                switch changeReason {
                case .oldDeviceUnavailable:
                    self.output?.didStop()
                default: break
                }
            }
        }
    }
    
    func configure(playerItem: AVPlayerItem) {
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.timedMetadata), options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.timedMetadata) {
            let playerItem = object as! AVPlayerItem
            if let firstMeta = playerItem.timedMetadata?.first {
                let metaData = firstMeta.value as! String
                if let data = metaData.data(using: .isoLatin1), let decodedString = NSString(data: data, encoding: String.Encoding.windowsCP1251.rawValue) {
                    output?.discoveredTrackInfo(info: decodedString as String)
                } else {
                    output?.discoveredTrackInfo(info: metaData)
                }
            }
        }
        
        guard let playerItem = object as? AVPlayerItem else {
            return
        }
        
        if keyPath == "playbackBufferEmpty" {
            print(keyPath!)
            if playerItem.isPlaybackBufferEmpty {
                // show loading indicator
                print("empty")
            }
            output?.didStartLoading()
        }
        
        if keyPath == "playbackLikelyToKeepUp" {
            print(keyPath!)
            if playerItem.isPlaybackLikelyToKeepUp {
                if (playerItem.status == .readyToPlay) {
                    // start playing
                    print("ready")
                    output?.didStart()
                }
                else if (playerItem.status == .failed) {
                    // handle failed
                    print("failed")
                }
                else if (playerItem.status == .unknown) {
                    // handle unknown
                    print("unknown")
                }
            }
        }
    }
    
    func play() {
        let newItem = AVPlayerItem(url: playerURL)
        configure(playerItem: newItem)
        player.replaceCurrentItem(with: newItem)    
        player.play()
        output?.didStartLoading()
    }
    
    func stop() {
        player.pause()
        output?.didStop()
        if let currentItem = player.currentItem {
            currentItem.removeObserver(self, forKeyPath: "timedMetadata")
            currentItem.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            currentItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        }
    }
    
    func configureWith(view: UIView) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect.zero
        view.layer.addSublayer(playerLayer)
    }
}

extension AVPlayer {
    var playing: Bool {
        get {
            return (rate != 0) && (error == nil)
        }
    }
}
