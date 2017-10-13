//
//  EntertainmentPlayer.swift
//  streamingMusicPlayer
//
//  Created by Miguel Tepale on 10/12/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import Foundation
import MediaPlayer

class EntertainmentPlayer {
    
    var audioVideoPlayer: AVPlayer!
    
    init() {
        audioVideoPlayer = AVPlayer()
    }
    
    func playStream (fileURL: String) {
        if let url = URL(string: fileURL) {
            audioVideoPlayer = AVPlayer(url: url)
            audioVideoPlayer.play()
            setPlayingScreen(fileURL: fileURL)
            
            print("Playing stream")
        }
        else {
            print("I can't play the stream")
        }
    }
    
    func playAudio () {
        if (audioVideoPlayer.rate == 0 && audioVideoPlayer.error == nil) {
            audioVideoPlayer.play()
        }
    }
    
    func pauseAudio () {
        if (audioVideoPlayer.rate > 0 && audioVideoPlayer.error == nil) {
            audioVideoPlayer.pause()
        }
    }
    
    func setPlayingScreen(fileURL: String) {
        let urlArray = fileURL.characters.split{$0 == "/"}.map(String.init)
        if let name = urlArray.last {
            print(name)
            let songInfo = [
                MPMediaItemPropertyTitle: name,
                MPMediaItemPropertyArtist: "Penny Play"
            ]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        }
        
        
    }
    
}
