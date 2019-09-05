//
//  NewLocationViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 29/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit
import MapKit

protocol NewLocationDelegate {
    func locationAnnotationAdded(annotation: LocationAnnotation)
}

class NewLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    weak var delegate: LocationTableViewController?
    weak var databaseController: DatabaseProtocol?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptTextField: UITextField!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var iconChoiceField: UISegmentedControl!
    
    let icons = ["Default", "Favourite", "Heritage", "Musicals", "Arts"]
    
    @IBAction func chooseIcon(_ sender: Any) {
        iconLabel.text = icons[iconChoiceField.selectedSegmentIndex]
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            controller.sourceType = .camera
            controller.allowsEditing = false
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            displayMessage("Camera is not available", "Error")
        }
    }
    
    @IBAction func usePhotoLibrary(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        guard let image = imageView.image else {
            displayMessage("Cannot save until a photo has been taken", "Error")
            return
        }
        
        let date = UInt(Date().timeIntervalSince1970)
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent("\(date)"){
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
        }
        
        if nameTextField.text == "" {
            displayMessage("Name cannot be empty", "Error")
        } else if longitudeLabel.text == "N/A" || latitudeLabel.text == "N/A"{
            displayMessage("Location cannot be empty", "Error")
        } else {
            let name = nameTextField.text!
            let descript = descriptTextField.text!
            let latitude = Double(latitudeLabel.text!)  ?? 0
            let longtitude = Double(longitudeLabel.text!) ?? 0
            let imageFilename = "\(date)"
            let iconFilename = icons[iconChoiceField.selectedSegmentIndex]
            
            let _ = databaseController?.addLocation(name: name, descript: descript, latitude: latitude, longitude: longtitude, imageFilename: imageFilename, iconFilename: iconFilename)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        if let currentLocation = currentLocation {
            latitudeLabel.text = String(format: "%.6f", currentLocation.latitude)
            longitudeLabel.text = String(format: "%.6f", currentLocation.longitude)
        } else {
            displayMessage("Cannot get current location", "Error")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the database controller from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        nameTextField.delegate = self
        descriptTextField.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location.coordinate
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        displayMessage("There was an error in getting the image", "Error")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage{
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func displayMessage(_ message: String, _ title: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
