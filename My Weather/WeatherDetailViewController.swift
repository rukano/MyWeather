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
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var forecastLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = weatherData {
            // set navigation bar
            title = data.city
            
            // set the placeholder labels
            temperatureLabel.text = data.temperature
            windLabel.text = data.wind
            pressureLabel.text = data.pressure
            forecastLabel.text = data.forecast
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

