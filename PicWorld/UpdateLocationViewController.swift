//
//  UpdateLocationViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 5/9/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit

class UpdateLocationViewController: UIViewController, UITextFieldDelegate {

    var location: Location?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptTextField: UITextField!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeTextField: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var iconChoiceField: UISegmentedControl!
    
    let icons = ["Default", "Favourite", "Heritage", "Musicals", "Arts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptTextField.delegate = self

        // Do any additional setup after loading the view.
        nameLabel.text = location?.name
        descriptTextField.text = location?.descript
        latitudeLabel.text = "\(location!.latitude)"
        longitudeTextField.text = "\(location!.longitude)"
        imageView.image = loadImageData(fileName: (location?.imageFilename!)!)
        iconChoiceField.selectedSegmentIndex = icons.firstIndex(of: location!.iconFilename!)!
        iconLabel.text = location?.iconFilename
        
    }
    @IBAction func chooseIcon(_ sender: Any) {
        iconLabel.text = icons[iconChoiceField.selectedSegmentIndex]
    }
    
    @IBAction func saveUpdateButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let dataController = appDelegate.databaseController as! CoreDataController
        let descript = descriptTextField.text
        let icon = icons[iconChoiceField.selectedSegmentIndex]
        
        dataController.updateLocation(location: location!, descript: descript!, iconFilename: icon)
        
        navigationController?.popViewController(animated: true)
        
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
            image = UIImage(named: "NotFound")
        }
        return image
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("Touch begins")
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
