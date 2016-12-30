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
import Crashlytics

protocol RadioViewInput {
    func setTrackInfo(trackInfo: String)
    func displayPause()
    func displayPlay()
    func displayLoading()
    func hideLoading()
}

protocol RadioViewOutput: class {
    func handleViewReady(view: UIView)
    func tappedPlay()
    func tappedPause()
    func tappedFacebook()
    func tappedVK()
    func tappedMail()
}

class ViewController: UIViewController, RadioViewInput {

    weak var output: RadioViewOutput?
    
    @IBOutlet weak var trackInfoLabel: UILabel!
    @IBOutlet weak var trackInfoBackgroundView: BorderedView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: BorderedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activityIndicator.transform = CGAffineTransform.identity.scaledBy(x: 2.5, y: 2.5)
        playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: [.highlighted, .selected])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        output?.handleViewReady(view: view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func togglePlayer(_ sender: AnyObject) {
        animateButton {
            print("is selected: \(self.playPauseButton.isSelected)")
//            self.playPauseButton.isSelected = !self.playPauseButton.isSelected
            
            if self.playPauseButton.isSelected {
                self.output?.tappedPause()
            } else {
                self.output?.tappedPlay()
            }
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        output?.tappedFacebook()
    }
    
    @IBAction func vkTapped(_ sender: Any) {
        output?.tappedVK()
    }
    
    @IBAction func mailTapped(_ sender: Any) {
        output?.tappedMail()
    }
    
    func setTrackInfo(trackInfo: String) {
        DispatchQueue.main.async {
            self.trackInfoBackgroundView.isHidden = false
            self.trackInfoLabel.text = trackInfo
        }
    }
    
    func displayPlay() {
        playPauseButton.isSelected = false
    }
    
    func displayPause() {
        playPauseButton.isSelected = true
    }
    
    func displayLoading() {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
        playPauseButton.isHidden = true
    }
    
    func hideLoading() {
        activityIndicatorContainer.isHidden = true
        activityIndicator.stopAnimating()
        playPauseButton.isHidden = false
    }
    
    func displayActivityIndicator() {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorContainer.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    override func remoteControlReceived(with receivedEvent: UIEvent?) {
        super.remoteControlReceived(with: receivedEvent)
        
        if receivedEvent!.type == UIEventType.remoteControl {
            
            switch receivedEvent!.subtype {
            case .remoteControlPlay:
                togglePlayer(self)
            case .remoteControlPause:
                togglePlayer(self)
            default:
                break
            }
        }
    }
    
    func animateButton(completion: @escaping () -> ()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        let animation = CABasicAnimation(keyPath: "transform")
        let tr = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1);
        animation.toValue = tr
        animation.duration = 0.2
        animation.autoreverses = true
        playPauseButton.layer.add(animation, forKey: "test")
        CATransaction.commit()
    }
}
