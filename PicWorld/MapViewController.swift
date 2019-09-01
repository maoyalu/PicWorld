//
//  MapViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 27/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController, DatabaseListener{

    @IBOutlet weak var mapView: MKMapView!
    
    var listenerType = ListenerType.location
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    weak var databaseController: DatabaseProtocol?
    var annotations = [LocationAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get the database controller from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let location = LocationAnnotation(newTitle: "Flinders St", newSubtitle: "Flinders Street station", lat: -37.8183, long: 144.9671)
        focusOn(annotation: location)
        
    }
    
    func focusOn(annotation: MKAnnotation){
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
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
        mapView.removeAnnotations(annotations)
        for location in locations{
            let annotation = LocationAnnotation(newTitle: location.name!, newSubtitle: location.descript!, lat: location.latitude, long: location.longitude)
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
