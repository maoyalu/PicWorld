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

class NewLocationViewController: UIViewController {
    weak var delegate: LocationTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
