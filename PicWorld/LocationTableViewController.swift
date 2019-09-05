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
    private let locationManager = CLLocationManager()
    var locationList = [Location]()
    var filteredLocationList = [Location]()
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    var sortAscend = true

    @IBAction func sortList(_ sender: Any) {
        if sortAscend {
            sortButton.image = UIImage(named: "SortZtoA")
            sortAscend = false
        } else {
            sortButton.image = UIImage(named: "SortAtoZ")
            sortAscend = true
        }
        locationList.reverse()
        filteredLocationList.reverse()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredLocationList = locationList
        
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
        return filteredLocationList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        let annotation = self.filteredLocationList[indexPath.row]
        
        cell.iconImageView.image = UIImage(named: annotation.iconFilename ?? "Default")
        cell.nameLabel.text = annotation.name
        cell.descriptLabel.text = annotation.descript

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 0
        let location = filteredLocationList[indexPath.row]
        let annotation = LocationAnnotation(newTitle: location.name!, newSubtitle: location.descript!, lat: location.latitude, long: location.longitude, image: location.imageFilename!, icon: location.iconFilename!)
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
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            let location = filteredLocationList[indexPath.row]
//
//            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//            let geoLocation = CLCircularRegion(center: coordinate, radius: 500, identifier: location.name!)
//            geoLocation.notifyOnEntry = true
//            locationManager.stopMonitoring(for: geoLocation)
//
//            databaseController?.deleteLocation(location: location)
////            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: {(action, indexPath) in
            let updateViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateLocationViewController") as! UpdateLocationViewController
            updateViewController.location = self.filteredLocationList[indexPath.row]
            self.navigationController?.pushViewController(updateViewController, animated: true)
        })
        
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) in
            let location = self.filteredLocationList[indexPath.row]
            
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let geoLocation = CLCircularRegion(center: coordinate, radius: 500, identifier: location.name!)
            geoLocation.notifyOnEntry = true
            self.locationManager.stopMonitoring(for: geoLocation)
            
            self.databaseController?.deleteLocation(location: location)
        })
        
        return [editAction, deleteAction]
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

extension LocationTableViewController: CLLocationManagerDelegate{
    
}
