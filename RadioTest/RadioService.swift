//
//  RadioService.swift
//  RadioTest
//
//  Created by O.Ohorbach on 10/7/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation

struct TrackInfo {
    let name: String?
    
    init(json: NSDictionary) {
        self.name = json.value(forKey: "track") as? String
    }
}

protocol RadioServiceOutput: class {
    func didUpdateTrackInfo(_ trackInfo: TrackInfo)
}

protocol RadioServiceInput {
    func startUpdatingTrackInfo()
    func stopUpdatingTrackInfo()
}

class RadioService: RadioServiceInput {
    
    weak var output: RadioServiceOutput?
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var updateTimer: Timer?
    
    func startUpdatingTrackInfo() {
        updateTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(RadioService.updateInfo), userInfo: nil, repeats: true)
    }
    
    func stopUpdatingTrackInfo() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @objc func updateInfo() {
        let trackInfoURL = URL(string: "https://www.radiobarmaglot.com/api/track_info")!
        defaultSession.dataTask(with: trackInfoURL, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    self.didReceiveTrackInfo(json as AnyObject)
                } catch {
                    
                }
            }
        }) .resume()
    }
    
    fileprivate func didReceiveTrackInfo(_ trackInfoJSON: AnyObject) {
        print(trackInfoJSON)
        
        let trackInfo = TrackInfo(json: trackInfoJSON as! NSDictionary)
        output?.didUpdateTrackInfo(trackInfo)
    }
}
