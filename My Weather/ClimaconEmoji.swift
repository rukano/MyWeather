//
//  ClimaconEmoji.swift
//  My Weather
//
//  This is a mapping from climacons (clima icons) codes to Climacon-Font characters
//  CZWeatherKit provides climacons characters
//  https://github.com/comyar/CZWeatherKit/blob/master/CZWeatherKit/CZClimacons.h
//  The font is provided by the app in the bundle
//  A second layer (Emojis) are mapped to smileys from the climacons types
//
//  Created by Juan A. Romero on 01/09/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import Foundation
import CZWeatherKit


// MARK: Emoji types mapping
enum Emoji : String {
    case Unknown = "🤔"
    case Great = "😎"
    case Happy = "😀"
    case Ok = "🙂"
    case Sleepy = "😴"
    case Sad = "😕"
    case Miserable = "😖"
    case Afraid = "😱"
    case Freezing = "😨"
}

// MARK: Climacon maping to emojis
struct ClimaconMood {
    static let moods = [
        Emoji.Great     : "\"IJKLMg",
        Emoji.Happy     : "B",
        Emoji.Ok        : "!%(:<CD",
        Emoji.Sleepy    : "#&),/58;>AENOPQRSTUV",
        Emoji.Sad       : "$+.<",
        Emoji.Miserable : "'*-9f",
        Emoji.Afraid    : "3467?@X",
        Emoji.Freezing  : "012W",
        // Add more motions if needed (hence the trailing comma)
    ]
    
    // Define a member variable so it gets automatically added to the initializer
    var char: String
    
    // Sinthesize the Emoji from the character given using the class dictionary
    var emoji: Emoji {
        get {
            // Access the static dictionary and map over it. Return only the pairs that satisfy the filter function
            let moods = ClimaconMood.moods.filter{ $0.1.containsString(char) }
            
            // If there are satisfying matches take the first one
            if let mood = moods.first {
                // And return the key [.0] -> Emoji
                return mood.0
            } else {
                // Otherwise return the unknown Emoji
                return Emoji.Unknown
            }
        }
    }
}
