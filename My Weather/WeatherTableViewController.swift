//
//  WeatherTableViewController.swift
//  My Weather
//
//  Created by Juan A. Romero on 30/08/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit
import CoreData

// Global key for notifications
let notificationKey = "de.rukano.MyWeatherDataUpdated"


class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    var weatherItems = [WeatherData]()
    
    // Indicator while fetching data
    var messageFrame = UIView()
    var messageLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    var isShowingSpinner = false
    
    // Search Bar
    lazy var searchBar = UISearchBar(frame: CGRectZero)
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        // Restore from last saved data
        let defaults = NSUserDefaults.standardUserDefaults()
//        print(defaults.dictionaryRepresentation())
        
        // Splash screen if it is the first time
        if !defaults.boolForKey("hasSeenSplashScreen") {
            print("Splash screen")
            defaults.setBool(true, forKey: "hasSeenSplashScreen")
        }
    
        // Load from city names
        let cities = defaults.objectForKey("cities") as? [String] ?? [String]()
        for city in cities {
            let data = WeatherData(city: city)
            data.requestData()
            weatherItems.append(data)
        }
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Pull to refresh target
        self.refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        // Receive Notifications
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: #selector(receiveNotificationFromWeatherData(_:)),
                       name: notificationKey,
                       object: nil)
        
        // Search Bar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "Enter city"
        navigationItem.titleView = searchBar

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func receiveNotificationFromWeatherData(sender: AnyObject) {
        // Reload the data in async queue
        // because of the autolayout and the activity indicator don't play well together
        
        dispatch_async(dispatch_get_main_queue(), {
            self.hideActivityIndicator()
            self.tableView.reloadData()
        })
        
        // save every time a new city has been updated
        // probably inefficient, but safe
        // should be probably done in the appDelegate or via CoreData
        self.saveCities()
    }
    
    func saveCities() {
        let cities = weatherItems.map { $0.city }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(cities, forKey: "cities")
        defaults.synchronize()
    }

    // MARK: IBActions
    @IBAction func getCityFromCurrentLocation(sender: UIBarButtonItem) {
        print("Try to use core location to get the current city")
    }
    
    func refresh() {
        // Refresh action from "pull to refresh" gesture
        for item in weatherItems {
            item.requestData()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        self.saveCities()
    }
    
    func showActivityIndicator() {
        // Show custom view in top of the view until data is loaded
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
    
    // MARK: Search bar delegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {

    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let city = searchBar.text {
            let data = WeatherData(city: city)
                data.requestData()
            self.weatherItems.append(data)
            self.showActivityIndicator()
        }
        searchBar.resignFirstResponder()
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
            cell.currentDescription.text = item.summary
            cell.currentEmoticon.text = item.emoticon
        } else {
            // In case there is no data loaded, display messages
            cell.currentTemperature.text = "❌"
            cell.currentDescription.text = "No data found"
            cell.currentEmoticon.text = "⚠️"
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
            
            // Save for the future
            saveCities()
            
            // Delete the cell
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
