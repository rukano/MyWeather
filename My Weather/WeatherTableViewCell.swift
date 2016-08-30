//
//  WeatherTableViewCell.swift
//  My Weather
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startedFetching() {
        activityIndicator.startAnimating()
    }

    func stoppedFetching() {
        activityIndicator.stopAnimating()
    }
    
}
