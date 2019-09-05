//
//  LocationAnnotation.swift
//  PicWorld
//
//  Created by Lu Yang on 27/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageFilename: String?
    var iconFilename: String?
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double, image: String, icon: String){
        title = newTitle
        subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        imageFilename = image
        iconFilename = icon
    }

}
