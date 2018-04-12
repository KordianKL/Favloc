//
//  UIColor+App.swift
//  Favloc
//
//  Created by Kordian Ledzion on 12/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var paleGrey: UIColor {
        return UIColor(red: 231, green: 234, blue: 238)
    }

    static var charcoalGrey: UIColor {
        return UIColor(red: 66, green: 68, blue: 82)
    }

    static var dodgerBlue: UIColor {
        return UIColor(red: 54, green: 166, blue: 248)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
}

