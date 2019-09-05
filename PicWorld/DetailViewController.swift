//
//  DetailViewController.swift
//  PicWorld
//
//  Created by Lu Yang on 2/9/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController{
    
    var location: LocationAnnotation?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        showDetail(location: location!)
        
        if location != nil {
            imageView.image = loadImageData(fileName: location!.imageFilename!)
            latitudeLabel.text = "\(location!.coordinate.latitude)"
            longitudeLabel.text = "\(location!.coordinate.longitude)"
            descriptLabel.text = location!.subtitle
            self.title = location!.title
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
            image = UIImage(named: "NotFound")
        }
        return image
    }
    
//    func showDetail(location: LocationAnnotation) {
//        descriptLabel.text = location.subtitle
//        latitudeLabel.text = "\(location.coordinate.latitude)"
//        longitudeLabel.text = "\(location.coordinate.longitude)"
//    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
