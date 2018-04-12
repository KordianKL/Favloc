//
//  Mocks.swift
//  Favloc
//
//  Created by Kordian Ledzion on 13/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

class Mocks {
    
    static let ahimsa = PlaceData(name: "Ahimsa",
                                  description: "Najlepsza wegańska restauracja we Wrocławiu. Zamawiaj Sizzlera!",
                                  photo: UIImagePNGRepresentation(UIImage(named: "ahimsa")!)! as NSData,
                                  longitiude: 51.1095232,
                                  latitiude: 17.0243928)
    
    static let pWr = PlaceData(name: "Politechnika Wrocławska",
                               description: "Uczelnia na której zdobyłem tytuł inżyniera. 8/10",
                               photo: UIImagePNGRepresentation(UIImage(named: "PWr")!)! as NSData,
                               longitiude: 51.1073907,
                               latitiude: 17.0619712)
    
    static let adSp = PlaceData(name: "Teatr AD Spectatores",
                                description: "Teatr, gdzie wystawiane są również oryginalne sztuki, najsłynniejsza we Wrocławiu - 9 REKONSTRUKCJA, gdzie widzowie biorą udział w przedstawieniu, ale na początku są przewożeni do lokalizacji - nie wiadomo jakiej.",
                                photo: UIImagePNGRepresentation(UIImage(named: "ADspec")!)! as NSData,
                                longitiude: 51.0919223,
                                latitiude: 17.0419084)
}

struct PlaceData {
    
    let name: String
    let description: String
    let photo: NSData
    let longitiude: Double
    let latitiude: Double
}
