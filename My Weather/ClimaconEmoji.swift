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

struct ClimaconEmoji {
    static let mapping = [
        Emoji.Great     : "\"IJKLMg",
        Emoji.Happy     : "B",
        Emoji.Ok        : "!%(:<CD",
        Emoji.Sleepy    : "#&),/58;>AENOPQRSTUV",
        Emoji.Sad       : "$+.<",
        Emoji.Miserable : "'*-9f",
        Emoji.Afraid    : "3467?@X",
        Emoji.Freezing  : "012W"
        // Add more motions if needed
    ]
    static func getEmojiFor(char: String) -> Emoji {
        // Start guessing emoji with unknown
        var emoji = Emoji.Unknown
        for (key, chars) in mapping {

            // if it finds the caracter in one of the values
            // set the emoji to be the key
            if chars.containsString(char) {
                emoji = key
            }
            // WARNING: the character can be contained in several of the values
            // It will return the last one found
            // To avoid this we can check if the character is repeated and throw a warning
            // or take the first one found or support an array of emojis for one character
        }
        return emoji
    }
}
