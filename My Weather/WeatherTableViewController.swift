//
//  WeatherTableViewController.swift
//  My Weather
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    // MARK: - Properties
    var weatherItems = [WeatherData]()

    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        var testItem1 = WeatherData()
        var testItem2 = WeatherData()
        var testItem3 = WeatherData()
        
        testItem1.city = "Berlin"
        testItem1.temperature = "30℃"

        testItem2.city = "Karlsruhe"
        testItem2.temperature = "38℃"
        
        testItem3.city = "Frankfurt"
        testItem3.temperature = "28℃"
        
        weatherItems += [testItem1, testItem2, testItem3]
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func addNewCity(sender: UIBarButtonItem) {
        print("Add new city and look for data")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! WeatherTableViewCell
        let item = weatherItems[indexPath.row]
        
        cell.cityName.text = item.city
        cell.currentTemperature.text = item.temperature
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            weatherItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let weatherDetail = segue.destinationViewController as! WeatherDetailViewController
            if let selectedWeatherCell = sender as? WeatherTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWeatherCell)!
                let selectedWeatherData = weatherItems[indexPath.row]
                weatherDetail.weatherData = selectedWeatherData
            }
        }
    }

}
