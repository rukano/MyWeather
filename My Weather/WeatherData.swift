//
//  WeatherData.swift
//  My Weather
//
//  This is the main model to represent, set and retreive weather data
//  It uses the cocoa pod CZWeatherKit for requesting the data over the internet
//  It requires an Open Weather Map API key which should be probably private
//  The key is provided for demonstration purposes
//
//  It consists of the data model WeatherRawData which gets the data from Open Weather Map
//  The model preserves the types of the original data
//  It also has a flag to know if the data was loaded or not
//
//  The WeatherData class stores the raw data in a variable and
//  provides synthesized members which access the data and provides
//  the data mostly as String or the adequate type (i.e. Double instead of Float)
//
//  Regardless if changes were made to the data or if the data was loaded sucessfully
//  a notification will be sent after every request
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

// TODO: Try to get locale on metric system and use the corresponding data in F/C or K/M

import Foundation
import CZWeatherKit

private struct WeatherRawData {
    var date: NSDate?
    var summary: String?
    var climacon: String?
    var humidity:Float?
    var temperature: Float?
    var pressure: Float?
    var windSpeed: Float?
    var windDirection: Float?
    var lowTemperature: Float?
    var highTemperature: Float?
}

class WeatherData : CustomStringConvertible  {
    // Class members
    static var apiKey: String?
    static var openRequests = 0
    
    // MARK: Instance Properties
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
        var speed = self.data.windSpeed!
        speed = round(speed * 10) / 10
        return "\(speed) km/h"
    }
    
    var windAngle: Double {
        return Double(self.data.windDirection!)
    }
    
    var windDirection: String {
        let angle = Double(self.data.windDirection!)
        let quadrant = (angle / 360.0) * 8
        let index = Int(round(quadrant))
        let direction = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"]
        return direction[index % 8]
    }
    
    var lowTemperature: String {
        return "\(self.data.lowTemperature!)℃"
    }
    
    var highTemperature: String {
        return "\(self.data.highTemperature!)℃"
    }
    
    var emoticon: String {
        return ClimaconMood(char: self.climacon).emoji.rawValue
    }
    
    var hasLoadedData = false
    
    var climacon: String {
        return self.data.climacon!
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

        // Prepare request
        let request = CZOpenWeatherMapRequest.newCurrentRequest()
        request.location = CZWeatherLocation(fromCity: self.city, country: "")
        
        if let key = WeatherData.apiKey {
            request.key = key
        } else {
            fatalError("Please provide a valid open weather map API key on the apikey.txt file")
        }

        print(self.city, "sending request...")

        // increment number of requests
        WeatherData.openRequests += 1

        // do the actual request
        request.sendWithCompletion { (data, error) in
            if data != nil {
                let current = data.current
                self.data.date = current.date
                self.data.summary = current.summary ?? ""
                self.data.humidity = current.humidity
                self.data.temperature = round(current.temperature.c)
                self.data.pressure = current.pressure.mb
                self.data.windSpeed = current.windSpeed.kph
                self.data.windDirection = current.windDirection
                self.data.lowTemperature = round(current.lowTemperature.c)
                self.data.highTemperature = round(current.highTemperature.c)
                self.data.climacon = String(NSString(format: "%c", current.climacon.rawValue))
                self.hasLoadedData = true
            } else {
                // Handle error
                self.hasLoadedData = false
            }
            
            // Reduce the requests
            WeatherData.openRequests -= 1
            
            // and notify the controller
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(notificationKey, object: self)

        }
    }
}












