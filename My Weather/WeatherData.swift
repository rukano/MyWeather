//
//  WeatherData.swift
//  My Weather
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import Foundation
import CZWeatherKit

private struct WeatherRawData {
    var date: NSDate?
    var summary: String?
    var climacon: Climacon?
    var humidity:Float?
    var temperature: Float?
    var pressure: Float?
    var windSpeed: Float?
    var windDirection: Float?
    var lowTemperature: Float?
    var highTemperature: Float?
    var hasLoadedData = false
}

class WeatherData : CustomStringConvertible  {
    // MARK: Class constants
    static let emoticonDict = [
        "ClearNight":   "🌜",
        "Clear":        "☀️",
        "Clouds":       "☁️",
        "Rain":         "🌧",
        "Drizzle":      "🌦",
        "Thunderstorm": "⛈",
        "Snow":         "🌨",
        "Atmosphere":   "🌫",
        "Extreme":      "🌪",
        "Additional":   "🌊",
        "Undefined":    "🌎",
        // TODO: Define night icons
        // Define more mappings if needed
        ]

    
    // MARK: Properties
    private var data = WeatherRawData()
    var city: String
    
    // Synthesized Properties (getters with string formatter)
    // since you should only change the raw data from the requests
    var temperature: String {
        return "\(Int(round(self.data.temperature!))) ℃"
    }
    var summary: String {
        return "\(self.data.summary!)"
    }
    var humidity: String {
        return "\(self.data.humidity!)%"
    }
    var pressure: String {
        return "\(self.data.pressure!) mB"
    }
    
    var windSpeed: String {
        return "\(self.data.windSpeed!) km/h"
    }
    
    var windDirection: String {
        var compassString = ""
        var angleQuadrant = 0
        let angle = Double(self.data.windDirection!)
        let angleRange = 45.0
        let angleOffset = 45.0 / 2.0
        let angleString = ["E", "NE", "N", "NW", "W", "SW", "S", "SE", "E"]
        
        for i in 0...8 {
            let startAngle = (Double(i) * angleRange) - angleOffset
            let endAngle = startAngle + angleRange
            if angle > startAngle && angle < endAngle {
                angleQuadrant = i
            }
        }
        
        compassString = angleString[angleQuadrant]
        return compassString
    }
    
    var lowTemperature: String {
        return "\(self.data.lowTemperature!)℃"
    }
    
    var highTemperature: String {
        return "\(self.data.highTemperature!)℃"
    }
    
    var emoticon: String {
        let key = self.data.summary!
        // Check if it's night
        let icon = WeatherData.emoticonDict[key]
        return icon ?? "🌍"
    }
    
    var hasLoadedData: Bool {
        return self.data.hasLoadedData
    }
    
    
    // Printable description
    var description: String {
        get {
            if self.hasLoadedData {
                return "\(self.city): \(self.temperature) with wind \(self.windDirection) at \(self.windSpeed)"
            } else {
                return "No data for city: \(self.city)"
            }
        }
    }
    
    // MARK: Initializers
    init(city: String) {
        self.city = city
    }
    
    func requestData() {
        let request = CZOpenWeatherMapRequest.newCurrentRequest()
        request.location = CZWeatherLocation(fromCity: self.city, country: "")
        request.key = "a6851128d8593e356875637eb02df696"
        print(self.city, "sending request...")
        request.sendWithCompletion { (data, error) in
            if data != nil {
                let current = data.current
                self.data.date = current.date
                self.data.summary = current.summary
                self.data.climacon = current.climacon
                self.data.humidity = current.humidity
                self.data.temperature = round(current.temperature.c)
                self.data.pressure = current.pressure.mb
                self.data.windSpeed = current.windSpeed.kph
                self.data.windDirection = current.windDirection
                self.data.lowTemperature = current.lowTemperature.c
                self.data.highTemperature = current.highTemperature.c
                self.data.hasLoadedData = true
                print(self.city, "request received!", )
            } else {
                // Handle error
            }
            self.notifyChange()
        }
    }
    
    func notifyChange () {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(notificationKey, object: self)
    }
}