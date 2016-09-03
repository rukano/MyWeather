//
//  WeatherTableViewCell.swift
//  My Weather
//
//  This are the table cells for the main view
//  The just contain the members from the view
//  The setup and initialization is handled from the main controller
//  since the tableView methods are implemented there
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentClimacon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
