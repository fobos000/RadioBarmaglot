//
//  ViewController.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/4/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    var player = AVPlayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let videoURL = NSURL(string: "https://www.radiobarmaglot.com/barmaglot")
        player = AVPlayer(URL: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func togglePlayer(sender: AnyObject) {
        if player.playing {
            player.pause()
        } else {
            player.play()
        }
    }
}

extension AVPlayer {
    var playing: Bool {
        get {
            return (rate != 0) && (error == nil)
        }
    }
}

