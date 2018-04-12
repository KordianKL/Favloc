//
//  Place+CoreDataClass.swift
//  Favloc
//
//  Created by Kordian Ledzion on 03/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

public class Place: NSManagedObject {
    
    var image: UIImage {
        if let data = photo {
            return UIImage(data: data as Data)!
        } else {
            return UIImage(named: "unknown")!
        }
    }

}
