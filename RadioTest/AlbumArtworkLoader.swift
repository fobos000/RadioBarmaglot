//
//  AlbumArtworkLoader.swift
//  RadioTest
//
//  Created by Ostap Horbach on 10/23/16.
//  Copyright © 2016 Ostap Horbach. All rights reserved.
//

import Foundation

struct TrackMetadata: Equatable {
    let title: String?
    let artist: String?
    
    static func ==(lhs: TrackMetadata, rhs: TrackMetadata) -> Bool {
        return lhs.title == rhs.title && lhs.artist == rhs.title
    }
}

protocol AlbumArtworkLoaderOutput: class {
    func didLoadArtwork(data: Data)
    func didFailToLoadArtwork()
}

protocol AlbumArtworkLoader {
    init(trackMetadata: TrackMetadata)
    func loadArtwork()
    var output: AlbumArtworkLoaderOutput? {get set}
}

class iTunesAlbumArtworkLoader: AlbumArtworkLoader {
    let queryURL = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=39d190869f66eb0301a8b75cf80efa81&artist=%@&track=%@&format=json"
    let trackMetadata: TrackMetadata
    weak var output: AlbumArtworkLoaderOutput?
    
    required init(trackMetadata: TrackMetadata) {
        self.trackMetadata = trackMetadata
    }
    
    func loadArtwork() {
        guard let artist = trackMetadata.artist, let title = trackMetadata.title else {
            return
        }
        
        let searchURL = String(format: queryURL, artist, title)
        let escapedURL = URL(string: searchURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        URLSession.shared.dataTask(with: escapedURL, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    self.didReceiveTrackInfo(json as AnyObject)
                } catch {
                    
                }
            }
        }) .resume()
    }
    
    fileprivate func extractArtworkURL(from json: AnyObject) -> String? {
        var artworkURL: String?
        if let infoDict = json as? NSDictionary,
           let trackInfo = infoDict["track"] as? NSDictionary,
           let albumInfo = trackInfo["album"] as? NSDictionary,
           let images = albumInfo["image"] as? NSArray,
           let imageInfo = images.lastObject as? NSDictionary,
           let imageURL = imageInfo["#text"] as? String {
            artworkURL = imageURL
        }
        return artworkURL
    }
    
    fileprivate func loadImageWith(url: URL, callback: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            callback(data)
        }.resume()
    }
    
    fileprivate func didReceiveTrackInfo(_ trackInfoJSON: AnyObject) {
        if let artworkURL = extractArtworkURL(from: trackInfoJSON) {
            guard let url = URL(string: artworkURL) else {
                DispatchQueue.main.async {
                    self.output?.didFailToLoadArtwork()
                }
                return
            }
            loadImageWith(url: url, callback: { (data) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.output?.didFailToLoadArtwork()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.output?.didLoadArtwork(data: data)
                }
            })
        }
    }
}
