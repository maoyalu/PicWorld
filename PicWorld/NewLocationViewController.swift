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

class NewLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    weak var delegate: LocationTableViewController?
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UILabel!
    @IBOutlet weak var longitudeTextField: UILabel!
    @IBOutlet weak var mapIconChoiceField: UISegmentedControl!
    
    
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
        } else {
            let name = nameTextField.text!
            let descript = descriptTextField.text!
            let latitude = Double(latitudeTextField.text!)  ?? 0
            let longtitude = Double(longitudeTextField.text!) ?? 0
            let imageFilename = "\(date)"
            
            let _ = databaseController?.addLocation(name: name, descript: descript, latitude: latitude, longitude: longtitude, imageFilename: imageFilename)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the database controller from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        nameTextField.delegate = self
        descriptTextField.delegate = self
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
