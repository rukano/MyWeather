//
//  ViewController.swift
//  My Weather
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var weatherData: WeatherData?
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var climaconLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var compassView: UIView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = weatherData {
            // set navigation bar
            title = data.city
            
            if data.hasLoadedData {
                // set the placeholder labels
                temperatureLabel.text       = data.temperature
                climaconLabel.text          = data.climacon
                highTemperatureLabel.text   = data.highTemperature
                lowTemperatureLabel.text    = data.lowTemperature
                moodLabel.text              = data.emoticon
                
                // TODO: Draw compass
                
                windSpeedLabel.text         = data.windSpeed
                windDirectionLabel.text     = data.windDirection
                humidityLabel.text          = data.humidity
                pressureLabel.text          = data.pressure
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

