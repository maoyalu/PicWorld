//
//  LocationTableViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 28/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit
import MapKit

protocol SelectLocationDelegate{
    func focusOn(annotation: MKAnnotation)
}

class LocationTableViewController: UITableViewController, NewLocationDelegate{
    
    var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    var delegate: SelectLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Focus on Flinders Street Station when the app starts
        
        var location = LocationAnnotation(newTitle: "Monash Uni - Caulfield", newSubtitle: "The Caulfield Campus of the Uni", lat: -37.877623, long: 145.045374)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
            
        location = LocationAnnotation(newTitle: "Monash Uni - Clayton", newSubtitle: "The Clayton Campus of the Uni", lat: -37.9105238, long: 145.1362182)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
    }
    
    func locationAnnotationAdded(annotation: LocationAnnotation) {
        locationList.append(annotation)
        mapViewController?.mapView.addAnnotation(annotation)
        tableView.insertRows(at: [IndexPath(row: locationList.count - 1, section: 0)], with: .automatic)
    }

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
        
        cell.textLabel?.text = annotation.title
        cell.detailTextLabel?.text = "Lat: \(annotation.coordinate.latitude) Long: \(annotation.coordinate.longitude)"

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 0
        mapViewController?.focusOn(annotation: self.locationList[indexPath.row])
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
            mapViewController?.mapView.removeAnnotation(locationList[indexPath.row])
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
