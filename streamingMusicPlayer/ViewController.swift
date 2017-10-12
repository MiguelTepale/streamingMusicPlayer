//
//  ViewController.swift
//  streamingMusicPlayer
//
//  Created by Miguel Tepale on 10/12/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    var audioVideoPlayer: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = ""
        if let streamingURL = URL(string: url) {
            audioVideoPlayer = AVPlayer(url: streamingURL)
            audioVideoPlayer.play()
        }
    }
}

