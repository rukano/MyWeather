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
    
    // Indicator while fetching data
    var messageFrame = UIView()
    var messageLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    
    var isShowingSpinner = false
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testItem1 = WeatherData(city: "Munich")
        testItem1.requestData()
        let testItem2 = WeatherData(city: "Paris")
        testItem2.requestData()
        let testItem3 = WeatherData(city: "Bogota")
        testItem3.requestData()
        
        weatherItems += [testItem1, testItem2, testItem3]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Pull to refresh target
        self.refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        // Receive Notifications
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: #selector(receiveNotificationFromWeatherData(_:)),
                       name: notificationKey,
                       object: nil)

        // Restore from last saved data
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func receiveNotificationFromWeatherData(sender: AnyObject) {
        // Reload the data in async queue
        // because of the autolayout and the activity indicator don't play well together
        // TODO: Maybe look for another solution for dismissing the activity indicator
        dispatch_async(dispatch_get_main_queue(), {
            self.hideActivityIndicator()
            self.tableView.reloadData()
        })

        
    }

    // MARK: IBActions
    func refresh() {
        
        // Refresh action from "pull to refresh" gesture
        for item in weatherItems {
            item.requestData()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func showActivityIndicator() {
        // Show custom view in top of the view until data is loaded
        // TODO: display spinner earlier and dismiss it when the data is laoded
        messageLabel = UILabel(frame: CGRect(x: 50, y:0, width: 200, height: 50))
        messageLabel.text = "Loading..."
        messageLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(messageLabel)
        view.addSubview(messageFrame)
        self.isShowingSpinner = true
    }
    
    func hideActivityIndicator() {
        // Dismiss loading indicator
        if self.isShowingSpinner {
            self.activityIndicator.stopAnimating()
            self.messageFrame.removeFromSuperview()
        }
    }
    
    
    @IBAction func addNewCity(sender: UIBarButtonItem) {
        // Create dialog for insterting city name
        let alert = UIAlertController(title: "Weather at", message: "Enter city", preferredStyle: .Alert)
        
        // Search action
        let searchAction = UIAlertAction(title: "Search", style: .Default) { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            let city = textField!.text!
            
            // Create and request city
            if city.characters.count > 0 {
                let data = WeatherData(city: city)
                data.requestData()
                self.weatherItems.append(data)
            }
            
        }

        // cancel Action
        let cancelAction = UIAlertAction(title:"Cancel", style: .Cancel) { (action:UIAlertAction) -> Void in
            print("cancel search")
        }
        
        // Build and Display Alert
        alert.addTextFieldWithConfigurationHandler { textField in }
        alert.addAction(cancelAction)
        alert.addAction(searchAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Populate cells with data from weatheItems data
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! WeatherTableViewCell
        let item = weatherItems[indexPath.row]
        
        // Set the cell labels with the required information
        cell.cityName.text = item.city
        
        if item.hasLoadedData {
            cell.currentTemperature.text = item.temperature
        } else {
            // In case there is no data loaded, display messages
            cell.currentTemperature.text = "No data"
        }
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
        
        // Check if the segue is the show detail connection
        if segue.identifier == "ShowDetail" {
            
            // grad the destination and populate it with the weather data
            let weatherDetail = segue.destinationViewController as! WeatherDetailViewController
            if let selectedWeatherCell = sender as? WeatherTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWeatherCell)!
                let selectedWeatherData = weatherItems[indexPath.row]
                weatherDetail.weatherData = selectedWeatherData
            }
        }
    }
}
