//
//  WeatherTableViewController.swift
//  My Weather

//  This is the main controller, here we will:
//  - Ppopulate the content of the table
//  - Handle the navigation, create the data model
//  - Make the requests to fetch data from the internet
//  - Receive and handle the notifications when the model aquires new data
//
//  We also handle the UI actions and store the data into defaults for later use
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
    let climaconsFont = UIFont(name: "Climacons-Font", size: 48.0)
    
    // Indicator while fetching data
    var activityIndicator = LoadingIndicatorView()
    var currentActiveRequests = 0
    
    // Search Bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get API key from file
        self.getApiKey()
        
        // Restore from last saved data
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Splash screen if it is the first time
        if !defaults.boolForKey("hasSeenSplashScreen") {
            displaySplashScreen()
            defaults.setBool(true, forKey: "hasSeenSplashScreen")
        }
        
        // Load from city names
        let cities = defaults.objectForKey("cities") as? [String] ?? [String]()
        for city in cities {
            let data = WeatherData(city: city)
            incrementRequests()
            data.requestData()
            weatherItems.append(data)
        }
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
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
        searchBar.delegate = self
        searchBar.placeholder = "Enter city"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func incrementRequests() {
        currentActiveRequests += 1
    }
    
    func decremetRequests() {
        currentActiveRequests -= 1
    }
    
    func receiveNotificationFromWeatherData(sender: AnyObject) {
        // Reload the data in async queue
        // because of the autolayout and the activity indicator don't play well together
        
        let item = sender.object as! WeatherData
        print(item.city, "notification received!")
        
        // decrease the active request count
        self.decremetRequests()
        
        // hide the activity indicator
        dispatch_async(dispatch_get_main_queue(), {
            self.hideActivityIndicator()
            self.tableView.reloadData()
        })
        
        // check if the refresher indicator is active
        if let refresher = self.refreshControl {
            // check if there are still requests in the pipeline
            // if it's the last one, then end the refreshing indicator
            if currentActiveRequests == 0 {
                refresher.endRefreshing()
            }
        }
        
        // save every time a new city has been updated
        // probably inefficient, but safe
        // should be probably done in the appDelegate or via CoreData
        self.saveCities()
    }
    
    // save to defaults so the same cities appear between sessions
    func saveCities() {
        let cities = weatherItems.map { $0.city }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(cities, forKey: "cities")
        defaults.synchronize()
    }

    // MARK: IBActions
    
    func refresh() {
        // Refresh action from "pull to refresh" gesture
        for item in weatherItems {
            // increase active requests for each request
            incrementRequests()
            item.requestData()
        }
        self.tableView.reloadData()
    }
    
    func showActivityIndicator() {
        activityIndicator = LoadingIndicatorView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        view.addSubview(activityIndicator)
    }
    
    func hideActivityIndicator() {
        // Dismiss loading indicator
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    func displaySplashScreen() {
        let filePath = NSBundle.mainBundle().pathForResource("changelog", ofType: "txt")
        let changes = try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding) as String
        let splashScreen = SplashScreenView(frame: UIScreen.mainScreen().bounds)
        splashScreen.setChanges(changes)
        UIApplication.sharedApplication().keyWindow!.addSubview(splashScreen)
    }
    
    func getApiKey() {
        let filePath = NSBundle.mainBundle().pathForResource("apikey", ofType: "txt")
        let key = try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding) as String
        WeatherData.apiKey = key
    }
    
    // MARK: Search bar delegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let city = self.searchBar.text {
            let data = WeatherData(city: city.capitalizedString)

            // increase the request count
            incrementRequests()
            data.requestData()
            
            // add the data to the list
            self.weatherItems.append(data)
            self.showActivityIndicator()
        }
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
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
        
        cell.currentClimacon.font = climaconsFont
        if item.hasLoadedData {
            cell.currentTemperature.text = item.temperature
            cell.currentDescription.text = item.summary
            cell.currentClimacon.text = item.climacon
        } else {
            // In case there is no data loaded, display messages
            cell.currentTemperature.text = "❌"
            cell.currentDescription.text = "No data found"
            cell.currentClimacon.text = "⚠️"
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
            
            // Grab the destination view and populate it with the weather data
            let weatherDetail = segue.destinationViewController as! WeatherDetailViewController
            if let selectedWeatherCell = sender as? WeatherTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWeatherCell)!
                let selectedWeatherData = weatherItems[indexPath.row]
                weatherDetail.weatherData = selectedWeatherData
            }
        }
    }
}
