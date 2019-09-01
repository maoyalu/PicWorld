//
//  DatabaseProtocol.swift
//  PicWorld
//
//  Created by Lu Yang on 31/8/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import Foundation

enum DatabaseChange{
    case add
    case remove
    case update
}

enum ListenerType{
    case location
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType{get set}
    func onLocationChange(change: DatabaseChange, locations: [Location])
}

protocol DatabaseProtocol: AnyObject {
    func addLocation(name: String, descript: String, latitude: Double, longitude: Double, imageFilename: String) -> Location
    func deleteLocation(location: Location)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
