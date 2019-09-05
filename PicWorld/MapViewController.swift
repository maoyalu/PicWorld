//
//  MapViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 27/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

//protocol LocationDetailDelegate: AnyObject {
//    func showDetail(location: LocationAnnotation)
//}

import UIKit
import MapKit
import UserNotifications

class MapViewController: UIViewController, DatabaseListener{

    @IBOutlet weak var mapView: MKMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listenerType = ListenerType.location
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    weak var databaseController: DatabaseProtocol?
    var annotations = [LocationAnnotation]()
//    weak var delegate: LocationDetailDelegate?
    
    var selectedLocation: LocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get the database controller from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        configureLocationServices()
        
        mapView.delegate = self
        
        let location = LocationAnnotation(newTitle: "Flinders St", newSubtitle: "Flinders Street station", lat: -37.8183, long: 144.9671, image: "None", icon: "Favourite")
        focusOn(annotation: location)
        
    }
    
    func focusOn(annotation: MKAnnotation){
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    private func configureLocationServices(){
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func onLocationChange(change: DatabaseChange, locations: [Location]) {
        
        mapView.removeAnnotations(annotations)
        
        for location in locations{
            let annotation = LocationAnnotation(newTitle: location.name!, newSubtitle: location.descript!, lat: location.latitude, long: location.longitude, image: location.imageFilename ?? "", icon: location.iconFilename ?? "")
            
            let geoLocation = CLCircularRegion(center: annotation.coordinate, radius: 500, identifier: annotation.title!)
            geoLocation.notifyOnEntry = true
            locationManager.startMonitoring(for: geoLocation)
            
//            let content = UNMutableNotificationContent()
//            content.title = "Notification Tutorial"
//            content.subtitle = "from ioscreator.com"
//            content.body = " Notification triggered"
//            
//            let trigger = UNLocationNotificationTrigger(region: geoLocation, repeats: true)
//            let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
            
        }
    }
    
    func loadImageData(fileName: String) -> UIImage?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if fileName != "default"{
            if let pathComponent = url.appendingPathComponent(fileName){
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                let fileData = fileManager.contents(atPath: filePath)
                if fileData != nil {
                    image = UIImage(data: fileData!)
                }
            }
        } else {
            image = UIImage(named: "Default")
        }
        return image
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "locationDetailSegue" {
            let destination = segue.destination as! DetailViewController
            
            destination.location = selectedLocation
        }
    }
    

}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }

        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Movement Detected!", message: "\(region.identifier) is nearby!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        appDelegate.scheduleNotification(title: "Movement Detected!", body: "\(region.identifier) is nearby!")
    }
}

extension MapViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation !== mapView.userLocation else {
            return nil
        }

        let annotation = annotation as? LocationAnnotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "LocationAnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LocationAnnotationView")
        }

        if let icon = annotation?.iconFilename{
            annotationView?.image = UIImage(named: icon)
        } else {
            annotationView?.image = UIImage(named: "Default")
        }

        annotationView?.canShowCallout = true
        
        if let image = annotation?.imageFilename{
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: annotationView!.frame.height, height: annotationView!.frame.height))
            
            imageView.image = loadImageData(fileName: image)
            imageView.contentMode = .scaleAspectFit
            
            annotationView?.leftCalloutAccessoryView = imageView
        }
        
        let rightButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = rightButton
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
//        if let detailNavController = storyboard?.instantiateViewController(withIdentifier: "DetailNavController") {
//            detailNavController.modalPresentationStyle = .popover
//            let presentationController = detailNavController.popoverPresentationController
//            presentationController?.permittedArrowDirections = .any
//
//            // Anchor the popover to the button that triggered the popover.
//            presentationController?.sourceRect = control.frame
//            presentationController?.sourceView = control
//
//            present(detailNavController, animated: true, completion: nil)
//        }
        selectedLocation = view.annotation as? LocationAnnotation
        self.performSegue(withIdentifier: "locationDetailSegue", sender: self)
    }
}


