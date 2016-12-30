//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
@testable import BarmaglotIOS

PlaygroundPage.current.needsIndefiniteExecution = true

let trackMetadata = TrackMetadata(title: "Here to stay", artist: "Korn")
let artworkLoader = iTunesAlbumArtworkLoader(trackMetadata: trackMetadata)

artworkLoader.loadArtwork()
