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
        
        // ============================= REPLACE =============================
        loadData()
        // ============================= REPLACE =============================
        
    }
    
    // ============================= REPLACE =============================
    func loadData(){

        var location = LocationAnnotation(newTitle: "St Michael's Uniting Church", newSubtitle: "St Michael's is a unique church in the heart of the city. It is not only unique for its relevant, contemporary preaching, but for its unusual architecture.", lat: -37.8143, long: 144.9697)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Royal Exhibition Building", newSubtitle: "The building is one of the world's oldest remaining exhibition pavilions and was originally built for the Great Exhibition of 1880. Later it housed the first Commonwealth Parliament from 1901, and was the first building in Australia to achieve a World Heritage listing in 2004.", lat: -37.804426, long: 144.971639)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Athenaeum Theatre", newSubtitle: "Book your place in history and catch a show in this heritage-listed building housing the Athenaeum Theatre, the Last Laugh at the Comedy Club and the Athenaeum Library. Take a seat for live theatre and music at the Athenaeum Theatre, or climb the grand staircase to the Last Laugh for stand-up comedy on weekends.", lat: -37.814784, long: 144.967370)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Flinders Street Station", newSubtitle: "Stand beneath the clocks of Melbourne's iconic railway station, as tourists and Melburnians have done for generations. Take a train for outer-Melbourne explorations, join a tour to learn more about the history of the grand building, or go underneath the station to see the changing exhibitions that line Campbell Arcade.", lat: -37.818144, long: 144.967042)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "St Paul's Cathedral", newSubtitle: "Leave the bustling Flinders Street Station intersection behind and enter the peaceful place of worship that's been at the heart of city life since the mid 1800s. Join a tour and admire the magnificent organ, the Persian Tile and the Five Pointed Star of the historic St Paul's Cathedral.", lat: -37.816906, long: 144.967692)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "St Patrick's Cathedral", newSubtitle: "Approach the mother church of the Catholic Archdiocese of Melbourne from the impressive Pilgrim Path, absorbing the tranquil sounds of running water and spiritual quotes before seeking sanctuary beneath the gargoyles and spires. Admire the splendid sacristy and chapels within, as well as the floor mosaics and brass items.", lat: -37.809787, long: 144.976374)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "The Scots' Church", newSubtitle: "Look up to admire the 120-foot spire of the historic Scots' Church, once the highest point of the city skyline. Nestled between modern buildings on Russell and Collins streets, the decorated Gothic architecture and stonework is an impressive sight, as is the interior's timber panelling and stained glass. Trivia buffs, take note: the church was built by David Mitchell, father of Dame Nellie Melba (once a church chorister).", lat: -37.814411, long: 144.968556)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Nicholas Building", newSubtitle: "Explore floor after floor of studios, galleries and curiosities in this heritage-listed creative hub. Shop for stunning textiles at Kimono House, found objects at Harold and Maude and vintage haberdashery at l'uccello. Trawl racks of vintage fashion at Retrostar or make an appointment for high-end millinery at Louise McDonald. Get behind the scenes and schedule your visit with one of the regular Open Studio days to see craftspeople at work in the historic studios. On the ground floor, browse the latest designs at Kuwaii and Obus in art deco Cathedral Arcade. Outside, stand back and admire the grandeur of the Renaissance palazzo-style architecture.", lat: -37.816527, long: 144.966751)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Manchester Unity Building", newSubtitle: "The Manchester Unity Building is one of Melbourne's most iconic Art Deco landmarks. It was built in 1932 for the Manchester Unity Independent Order of Odd Fellows (IOOF), a friendly society providing sickness and funeral insurance. Melbourne architect Marcus Barlow took inspiration from the 1927 Chicago Tribune Building. His design incorporated a striking New Gothic style façade of faience tiles with ground-floor arcade and mezzanine shops, café and rooftop garden. Step into the arcade for a glimpse of the marble interior, beautiful friezes and restored lift – or book a tour for a peek upstairs.", lat: -37.815132, long: 144.966322)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Trades Hall", newSubtitle: "Established in 1859 as a meeting hall and a place to educate workers and their families - Trades Hall is still home to trade unions and political events - but has grown to embrace a diverse cultural focus. It's now a regular venue for theatre, art exhibitions, Melbourne International Comedy Festival and Melbourne Fringe Festival.", lat: -37.806397, long: 144.966058)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Melbourne Tram Museum", newSubtitle: "Open to the public every second and fourth Saturday of each month, the Melbourne Tram Museum preserves and shares the rich tramway history of Melbourne, with something for all ages.", lat: -37.827079, long: 145.024697)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Old Melbourne Gaol", newSubtitle: "Step back in time to Melbourne’s most feared destination since 1845, Old Melbourne Gaol. ", lat: -37.807620, long: 144.965296)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Polly Woodside", newSubtitle: "Climb aboard and roam the decks of the historic Polly Woodside, one of Australia’s last surviving 19th century tall ships. ", lat: -37.824299, long: 144.953565)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Parliament of Victoria", newSubtitle: "Victoria's Parliament House - one of Australia's oldest and most architecturally distinguished public buildings. ", lat: -37.810818, long: 144.973800)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(newTitle: "Koorie Heritage Trust", newSubtitle: "The Koorie Heritage Trust is a bold and adventurous 21st century Aboriginal arts and cultural organisation. ", lat: -37.817941, long: 144.969152)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
    }
    // ============================= REPLACE =============================
    
    
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
