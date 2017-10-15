//
//  Song.swift
//  streamingMusicPlayer
//
//  Created by Miguel Tepale on 10/14/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import Foundation

class Song {
    var id: Int
    var name: String
    var numberOfLikes: Int
    var numberOfPlays: Int
    
    init? (id: String, name: String, numberOfLikes: String, numberOfPlays: String) {
        self.id = Int(id)!
        self.name = name
        self.numberOfLikes = Int(numberOfLikes)!
        self.numberOfPlays = Int(numberOfPlays)!
    }
    
    func getId() -> Int {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getNumberOfLikes() -> Int {
        return numberOfLikes
    }
    
    func getNumberOfPlays() -> Int {
        return numberOfPlays
    }
}
