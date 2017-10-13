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
    
    @IBOutlet weak var playPauseButton: UIButton!
    var player: EntertainmentPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVAudioSessionInterruption, object: nil)
        
        player = EntertainmentPlayer()
        
        let url = "https://migueldevelopments.000webhostapp.com/music_app/dubstep.mp3"
        player.playStream(fileURL: url)
        changePlayButton()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func playPauseDidTap(_ sender: UIButton) {
        if player.audioVideoPlayer.rate > 0 {
            player.pauseAudio()
        }
        else {
            player.playAudio()
        }
        changePlayButton()
    }
    
    func changePlayButton() {
        if player.audioVideoPlayer.rate > 0 {
            playPauseButton.setImage(UIImage(named:"pause"), for: .normal)
            print("play button pressed")
        }
        else {
            playPauseButton.setImage(UIImage(named:"play"), for: .normal)
            print("pause button pressed")
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEventType.remoteControl {
            if event!.subtype == UIEventSubtype.remoteControlPause {
                print("Airplay pause pressed")
                player.pauseAudio()
            }
            else if event!.subtype == UIEventSubtype.remoteControlPlay {
                print("Airplay play pressed")
                player.playAudio()
            }
        }
    }
    
    @objc func handleInterruption(notifcation: Notification) {
        player.pauseAudio()
        
        let interruptionTypeAsObject = notifcation.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
        let interruptionType = AVAudioSessionInterruptionType(rawValue: interruptionTypeAsObject)
        
        if let type = interruptionType {
            if type == .ended {
                player.playAudio()
            }
        }
    }
    
}

