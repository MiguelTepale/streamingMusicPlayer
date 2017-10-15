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
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVAudioSessionInterruption, object: nil)
        
        player = EntertainmentPlayer()
        
        retrieveSongs()
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
    
    func retrieveSongs() {
        guard let url = URL(string: "https://migueldevelopments.000webhostapp.com/music_app/getMusic.php") else {
            print("Something wrong with url from 'retrieveSongs' function")
            return
        }
        
        URLSession.shared.dataTask(with: url) {(data, respone, error) in
            guard let urlData = data, error == nil else {
                return
            }
            if let retrievedList = String(data: urlData, encoding: .utf8) {
            print(retrievedList)
            self.parseSongs(data: retrievedList)
            }
        }
        .resume()
    }
    
    func parseSongs(data: String) {
        if (data.range(of:"*") != nil) {
            let dataArray = (data as String).characters.split{$0 == "*"}.map(String.init)
            for item in dataArray {
                let itemData = item.characters.split{$0 == ","}.map(String.init)
                if let newSong = Song(id: itemData[0], name: itemData[1], numberOfLikes: itemData[02], numberOfPlays: itemData[3]) {
                    songs.append(newSong)
                }
            }
            for song in songs {
                print(song.getName())
            }
        }
        
    }
    
}

