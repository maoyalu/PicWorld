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
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double){
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

}
