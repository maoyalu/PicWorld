//
//  Location+CoreDataProperties.swift
//  PicWorld
//
//  Created by Lu Yang on 31/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var descript: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var imageFilename: String?

}
