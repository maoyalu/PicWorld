//
//  LocationTableViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 28/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener{
    
    var listenerType = ListenerType.location
    var mapViewController: MapViewController?
    var locationList = [Location]()
    var filteredLocationList = [Location]()
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database controller from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sights"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Focus on Flinders Street Station when the app starts
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onLocationChange(change: DatabaseChange, locations: [Location]) {
        locationList = locations
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            filteredLocationList = locationList.filter({(location: Location) -> Bool in
                return location.name!.contains(searchText)
            })
        } else {
            filteredLocationList = locationList
        }
        
        tableView.reloadData()
    }
    
//    func locationAnnotationAdded(annotation: LocationAnnotation) {
//        locationList.append(annotation)
//        mapViewController?.mapView.addAnnotation(annotation)
//        tableView.insertRows(at: [IndexPath(row: locationList.count - 1, section: 0)], with: .automatic)
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let annotation = self.locationList[indexPath.row]
        
        cell.textLabel?.text = annotation.name
        cell.detailTextLabel?.text = "Lat: \(annotation.latitude) Long: \(annotation.longitude)"

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 0
        let location = locationList[indexPath.row]
        let annotation = LocationAnnotation(newTitle: location.name!, newSubtitle: location.descript!, lat: location.latitude, long: location.longitude)
        mapViewController?.focusOn(annotation: annotation)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let location = locationList[indexPath.row]
            databaseController?.deleteLocation(location: location)
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "newLocationSegue"{
            let destination = segue.destination as! NewLocationViewController
            destination.delegate = self
        }
        // Pass the selected object to the new view controller.
        
    }
    

}
