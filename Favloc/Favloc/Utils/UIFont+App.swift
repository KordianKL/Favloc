//
//  UIFont+App.swift
//  Favloc
//
//  Created by Kordian Ledzion on 12/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func appMediumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: fontSize)!
    }
    
    static func appBoldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: fontSize)!
    }
    
    static func appDemiBoldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: fontSize)!
    }
}
