//
//  Place+CoreDataProperties.swift
//  Favloc
//
//  Created by Kordian Ledzion on 14/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var desc: String?
    @NSManaged public var index: Int16
    @NSManaged public var latitiude: Double
    @NSManaged public var longitiude: Double
    @NSManaged public var name: String?
    @NSManaged public var photo: NSData?

}
