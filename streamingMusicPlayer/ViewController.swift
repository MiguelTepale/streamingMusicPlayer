//
//  ViewController.swift
//  streamingMusicPlayer
//
//  Created by Miguel Tepale on 10/12/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import UIKit
import MediaPlayer
import Social
import Accounts

class ViewController: UIViewController {
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var songsTableView: UITableView!
    
    var currentId: Int!
    var currentSong: Song!
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
    
    @IBAction func facebookButtonDidTap(_ sender: UIButton) {
        shareToFacebook()
    }
    @IBAction func likeButtonDidTap(_ sender: UIButton) {
        if let id = currentId {
        likeSong(id: id)
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
        print("Getting songs")
    }
    
    func songPlayed(id: Int) {
        guard let url = URL(string: "https://migueldevelopments.000webhostapp.com/music_app/add_play.php?id=" + String(id)) else {
            print("Something wrong with url from 'retrieveSongs' function")
            return
        }
        URLSession.shared.dataTask(with: url) {(data, respone, error) in
            guard let urlData = data, error == nil else {
                return
            }
            if let retrievedData = String(data: urlData, encoding: .utf8) {
                print(retrievedData)
            }
            }
            .resume()
        print("Liking song")
    }
    
    func likeSong(id: Int) {
        guard let url = URL(string: "https://migueldevelopments.000webhostapp.com/music_app/like_song.php?id=" + String(id)) else {
            print("Something wrong with url from 'retrieveSongs' function")
            return
        }
        URLSession.shared.dataTask(with: url) {(data, respone, error) in
            guard let urlData = data, error == nil else {
                return
            }
            if let retrievedData = String(data: urlData, encoding: .utf8) {
                print(retrievedData)
            }
            }
            .resume()
        print("User liking song")
    }

    
    func parseSongs(data: String) {
        if (data.range(of:"*") != nil) {
            let dataArray = (data as String).characters.split{$0 == "*"}.map(String.init)
            for item in dataArray {
                let itemData = item.characters.split{$0 == ","}.map(String.init)
                if let newSong = Song(id: itemData[0], name: itemData[1], numberOfLikes: itemData[02], numberOfPlays: itemData[3], artist: itemData[4]) {
                    songs.append(newSong)
                }
             }
            for song in songs {
                print(song.getName())
            }
            DispatchQueue.main.async {
                self.songsTableView.reloadData()
            }
        }
    }
    
    func shareToFacebook() {
        if let song = currentSong {
            if let viewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            viewController.setInitialText("Listening to: " + song.getName() + "by" + song.getArtistName() + ".Penny Play App")
//            viewController.add(URL(string: "https://github.com/MiguelTepale"))
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = songsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongsTableViewCell
        cell.mainLabel.text = songs[indexPath.row].getSongName()
        cell.artistLabel.text = songs[indexPath.row].getArtistName()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songsTableView.deselectRow(at: indexPath, animated: true)
        player.playStream(fileURL: "https://migueldevelopments.000webhostapp.com/music_app/" + songs[indexPath.row].getArtistName() + "-" + songs[indexPath.row].getName())
        changePlayButton()
        nowPlayingLabel.text = songs[indexPath.row].getSongName()
        songPlayed(id: songs[indexPath.row].getId())
        currentId = songs[indexPath.row].getId()
        currentSong = songs[indexPath.row]
    }
    
}

