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
    
    var player: EntertainmentPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = EntertainmentPlayer()
        
        let url = ""
        player.playStream(fileURL: url)
    }
}

