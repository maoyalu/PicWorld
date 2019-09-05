//
//  CoreDataController.swift
//  PicWorld
//
//  Created by Lu Yang on 1/9/19.
//  Copyright © 2019 Lu Yang. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    var locationsFetchedResultsController: NSFetchedResultsController<Location>?
    
    override init() {
        persistantContainer = NSPersistentContainer(name: "PicWorld")
        persistantContainer.loadPersistentStores(){(description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        if fetchAllLocations().count == 0{
            createDefaultEntries()
        }
    }
    
    func saveContext(){
        if persistantContainer.viewContext.hasChanges{
            do{
                try persistantContainer.viewContext.save()
            } catch{
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func fetchAllLocations() -> [Location]{
        if locationsFetchedResultsController == nil{
            let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            locationsFetchedResultsController = NSFetchedResultsController<Location>(fetchRequest: fetchRequest,managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            locationsFetchedResultsController?.delegate = self
            
            do{
                try locationsFetchedResultsController?.performFetch()
            } catch{
                print("Fetch Request failed: \(error)")
            }
        }
        
        var locations = [Location]()
        if locationsFetchedResultsController?.fetchedObjects != nil{
            locations = (locationsFetchedResultsController?.fetchedObjects)!
        }
        
        return locations
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == locationsFetchedResultsController{
            listeners.invoke{(listener) in
                if listener.listenerType == ListenerType.location{
                    listener.onLocationChange(change: .update, locations: fetchAllLocations())
                }
            }
        }
    }
    
    func addLocation(name: String, descript: String, latitude: Double, longitude: Double, imageFilename: String, iconFilename: String) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: persistantContainer.viewContext) as! Location
        location.name = name
        location.descript = descript
        location.latitude = latitude
        location.longitude = longitude
        location.imageFilename = imageFilename
        location.iconFilename = iconFilename
        saveContext()
        return location
    }
    
    func deleteLocation(location: Location) {
        persistantContainer.viewContext.delete(location)
        saveContext()
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.location{
            listener.onLocationChange(change: .update, locations: fetchAllLocations())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func createDefaultEntries(){
        let ICON_HERITAGE = "Heritage"
        let ICON_MUSICALS = "Musicals"
        let ICON_DEFAULT = "Default"
        let ICON_ARTS = "Arts"
        
        let _ = addLocation(name: "St Michael's Uniting Church", descript: "St Michael's is a unique church in the heart of the city. It is not only unique for its relevant, contemporary preaching, but for its unusual architecture.", latitude: -37.8143, longitude: 144.9697, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "Royal Exhibition Building", descript: "The building is one of the world's oldest remaining exhibition pavilions and was originally built for the Great Exhibition of 1880. Later it housed the first Commonwealth Parliament from 1901, and was the first building in Australia to achieve a World Heritage listing in 2004.", latitude: -37.804426, longitude: 144.971639, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "Athenaeum Theatre", descript: "Book your place in history and catch a show in this heritage-listed building housing the Athenaeum Theatre, the Last Laugh at the Comedy Club and the Athenaeum Library. Take a seat for live theatre and music at the Athenaeum Theatre, or climb the grand staircase to the Last Laugh for stand-up comedy on weekends.", latitude: -37.814784, longitude: 144.967370, imageFilename: "default", iconFilename: ICON_MUSICALS)
        
        let _ = addLocation(name: "Flinders Street Station", descript: "Stand beneath the clocks of Melbourne's iconic railway station, as tourists and Melburnians have done for generations. Take a train for outer-Melbourne explorations, join a tour to learn more about the history of the grand building, or go underneath the station to see the changing exhibitions that line Campbell Arcade.", latitude: -37.818144, longitude: 144.967042, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "St Paul's Cathedral", descript: "Leave the bustling Flinders Street Station intersection behind and enter the peaceful place of worship that's been at the heart of city life since the mid 1800s. Join a tour and admire the magnificent organ, the Persian Tile and the Five Pointed Star of the historic St Paul's Cathedral.", latitude: -37.816906, longitude: 144.967692, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "St Patrick's Cathedral", descript: "Approach the mother church of the Catholic Archdiocese of Melbourne from the impressive Pilgrim Path, absorbing the tranquil sounds of running water and spiritual quotes before seeking sanctuary beneath the gargoyles and spires. Admire the splendid sacristy and chapels within, as well as the floor mosaics and brass items.", latitude: -37.809787, longitude: 144.976374, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "The Scots' Church", descript: "Look up to admire the 120-foot spire of the historic Scots' Church, once the highest point of the city skyline. Nestled between modern buildings on Russell and Collins streets, the decorated Gothic architecture and stonework is an impressive sight, as is the interior's timber panelling and stained glass. Trivia buffs, take note: the church was built by David Mitchell, father of Dame Nellie Melba (once a church chorister).", latitude: -37.814411, longitude: 144.968556, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "Nicholas Building", descript: "Explore floor after floor of studios, galleries and curiosities in this heritage-listed creative hub. Shop for stunning textiles at Kimono House, found objects at Harold and Maude and vintage haberdashery at l'uccello. Trawl racks of vintage fashion at Retrostar or make an appointment for high-end millinery at Louise McDonald. Get behind the scenes and schedule your visit with one of the regular Open Studio days to see craftspeople at work in the historic studios. On the ground floor, browse the latest designs at Kuwaii and Obus in art deco Cathedral Arcade. Outside, stand back and admire the grandeur of the Renaissance palazzo-style architecture.", latitude: -37.816527, longitude: 144.966751, imageFilename: "default", iconFilename: ICON_HERITAGE)

        let _ = addLocation(name: "Manchester Unity Building", descript: "The Manchester Unity Building is one of Melbourne's most iconic Art Deco landmarks. It was built in 1932 for the Manchester Unity Independent Order of Odd Fellows (IOOF), a friendly society providing sickness and funeral insurance. Melbourne architect Marcus Barlow took inspiration from the 1927 Chicago Tribune Building. His design incorporated a striking New Gothic style façade of faience tiles with ground-floor arcade and mezzanine shops, café and rooftop garden. Step into the arcade for a glimpse of the marble interior, beautiful friezes and restored lift – or book a tour for a peek upstairs.", latitude: -37.815132, longitude: 144.966322, imageFilename: "default", iconFilename: ICON_HERITAGE)

        let _ = addLocation(name: "Trades Hall", descript: "Established in 1859 as a meeting hall and a place to educate workers and their families - Trades Hall is still home to trade unions and political events - but has grown to embrace a diverse cultural focus. It's now a regular venue for theatre, art exhibitions, Melbourne International Comedy Festival and Melbourne Fringe Festival.", latitude: -37.806397, longitude: 144.966058, imageFilename: "default", iconFilename: ICON_HERITAGE)
      
        let _ = addLocation(name: "Melbourne Tram Museum", descript: "Open to the public every second and fourth Saturday of each month, the Melbourne Tram Museum preserves and shares the rich tramway history of Melbourne, with something for all ages.", latitude: -37.827079, longitude: 145.024697, imageFilename: "default", iconFilename: ICON_HERITAGE)
        
        let _ = addLocation(name: "Old Melbourne Gaol", descript: "Step back in time to Melbourne’s most feared destination since 1845, Old Melbourne Gaol. ", latitude: -37.807620, longitude: 144.965296, imageFilename: "default", iconFilename: ICON_HERITAGE)

        let _ = addLocation(name: "Polly Woodside", descript: "Climb aboard and roam the decks of the historic Polly Woodside, one of Australia’s last surviving 19th century tall ships. ", latitude: -37.824299, longitude: 144.953565, imageFilename: "default", iconFilename: ICON_DEFAULT)

        let _ = addLocation(name: "Parliament of Victoria", descript: "Victoria's Parliament House - one of Australia's oldest and most architecturally distinguished public buildings. ", latitude: -37.810818, longitude: 144.973800, imageFilename: "default", iconFilename: ICON_HERITAGE)

        let _ = addLocation(name: "Koorie Heritage Trust", descript: "The Koorie Heritage Trust is a bold and adventurous 21st century Aboriginal arts and cultural organisation. ", latitude: -37.817941, longitude: 144.969152, imageFilename: "default", iconFilename: ICON_ARTS)

    }
    

}
